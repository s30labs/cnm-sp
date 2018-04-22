#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME:  linux_metric_file_server.pl
# AUTHOR: <fmarin\@s30labs.com>
# DATE: 26/03/2018
# VERSION: 1.0
#
# DESCRIPTION:
# Monitoriza que se transfieren correctamente ficheros al servidor especificado
# 0=OK | 1=UNK | 2=Error | 3=UNK
#
# USAGE:
# linux_metric_file_server.pl -host 1.1.1.1 -user user1 -pwd xxx [-port 22|...] [-proto sftp|...] [-files 10|...] [-size 100000|...] [-v]
# linux_metric_file_server.pl -h  : Help
#
# -host       : File Server Host
# -port       : Port (default 22)
# -user       : Server User
# -pwd        : Server User Password
# -proto      : Protocol (default sftp)
# -files      : Number of files used (tx/rx). Default is 10.
# -size       : Aggregated size. Default is 300KB.
# -v/-verbose : Verbose output (debug)
# -h/-help    : Help
#
# OUTPUT:
# <001> File Transfer Latency = 0.008458
# <002> File Transfer Success = 100
#
# </CNMDOCU>
#--------------------------------------------------------------------
MYHEADER
};
use lib '/opt/crawler/bin/';
use strict;
use warnings;
use Getopt::Long;
use CNMScripts;
use Data::Dumper;
use Digest::MD5 qw(md5_hex);
use Time::HiRes qw(gettimeofday tv_interval);
use Net::SFTP::Foreign;

#--------------------------------------------------------------------
#--------------------------------------------------------------------
my $script = CNMScripts->new();
my %opts = ();
my $ok=GetOptions (\%opts,  'h','help','v','verbose','user=s','pwd=s','port=s','host=s','proto=s','files=s','size=s' );
if (! $ok) {
	print STDERR "***ERROR EN EL PASO DE PARAMETROS***\n";	
	$script->usage($main::MYHEADER); 
	exit 1;
}

my $VERBOSE = ((defined $opts{'v'}) || (defined $opts{'verbose'})) ? 1 : 0;

if ( ($opts{'h'}) || ($opts{'help'})) { $script->usage($main::MYHEADER); }

my $host = ($opts{'host'}) ? $opts{'host'} : $script->usage($main::MYHEADER);

my $proto = (defined $opts{'proto'}) ? $opts{'proto'} : 'sftp';
my $port =22;
if ($proto=~/sftp/i) { $port =22; }
 
#$script->port($port);

my $user = (defined $opts{'user'}) ? $opts{'user'} : '';
my $pwd = (defined $opts{'pwd'}) ? $opts{'pwd'} : '';

my $NUM_FILES = (defined $opts{'files'}) ? $opts{'files'} : 10;		# 10 files
my $TOTAL_SIZE = (defined $opts{'size'}) ? $opts{'size'} : 300000;   # 300KB

if ($VERBOSE) {
   print "PARAMETERS *****\n";
   print Dumper (\%opts);
   print "ip=$host port=$port user=$user pwd=$pwd\n";
   print "*****\n";
}

#--------------------------------------------------------------------
my ($r,$data,$value) = ('','',0);
# $value => 0=OK | 1=UNK  | 2=Error en getToken | 3=Error en validateToken
$script->test_init('001', "File Transfer Latency (sg)");
$script->test_init('002', "File Transfer Success (%)");



#--------------------------------------------------------------------
my $t0=[gettimeofday];

#--------------------------------------------------------------------
my $sftp = Net::SFTP::Foreign->new( $host, 'port'=>$port, 'user'=>$user, 'password'=>$pwd );
if (! $sftp) {
	$sftp->die_on_error("Unable to establish SFTP connection");
}

my @TEST_FILES = ();
my $SCRATCH_DIR = '/tmp/scratch';
if (! -d $SCRATCH_DIR) { mkdir $SCRATCH_DIR; }
my $CHUNK_SIZE=5;
my $TOP_RANDOM=100000; # Tantos ceros como $CHUNK_SIZE
my $chunks_per_file = int($TOTAL_SIZE/($NUM_FILES*$CHUNK_SIZE));
foreach my $i (1..$NUM_FILES) {
	my $ii = sprintf("%03d",$i);
   my $fnametx = $SCRATCH_DIR.'/cnm_file_server_local_'.$ii.'.txt';
   my $fnamerx = 'cnm_file_server_remote_'.$ii.'.txt';
	my $pattern = int(rand($TOP_RANDOM));
   open (F, ">$fnametx");
   print F $pattern x $chunks_per_file;
   close F;
   my $md5 = get_file_md5($fnametx);
   push @TEST_FILES,{ 'fnametx'=>$fnametx, 'fnamerx'=>$fnamerx, 'md5'=>$md5 };
}

my $x=1;
foreach my $h (@TEST_FILES) {

	my $ok = $sftp->put($h->{'fnametx'}, $h->{'fnamerx'});
	if (! $ok) { print STDERR "put failed: " . $sftp->error. "\n"; }
	elsif ($VERBOSE) { 
		my $xf = sprintf("%03d",$x);
		print "PUT FILE [$xf] >> OK >> $h->{'fnametx'} >> [$h->{'md5'}]\n"; 
	}
	$x++;
}


$x=1;
my $num_ok=0;
foreach my $h (@TEST_FILES) {

	my $frx=$SCRATCH_DIR.'/'.$h->{'fnamerx'};
   my $ok = $sftp->get($h->{'fnamerx'},$frx);
   if (! $ok) { print STDERR "GET failed: " . $sftp->error. "\n"; }
   else {
		my $md5 = get_file_md5($frx);
		my $md5check = 'ERROR';
		if ($md5 eq $h->{'md5'}) { 
			$md5check = 'OK'; 
			$num_ok++;
		} 
		if ($VERBOSE) { 
			my $xf = sprintf("%03d",$x);
			print "GET FILE [$xf] >> $md5check >> $frx >> $md5\n"; 
		}
	}
	$sftp->remove($h->{'fnamerx'});
   $x++;
}


my $t1=[gettimeofday];
my $elapsed = tv_interval ( $t0, $t1);
my $elapsed3 = sprintf("%.6f", $elapsed);
$script->test_done('001',$elapsed3);

my $code = $sftp->status();
my $error = $sftp->error();
if (($code == 0) && ($error=~/success/i)) { $value=0; }
else {
	$script->log('info',"**ERROR** host=$host port=$port user=$user pwd=$pwd [$code - $error]");

}
if ($VERBOSE) {
	print "*** --- $code -- $error\n";
}

$value = int(($num_ok/$NUM_FILES)*100);
$script->test_done('002',$value);
$script->print_metric_data();

exit 0;


#--------------------------------------------------------------------
#--------------------------------------------------------------------
sub get_file_md5 {
my ($file)=@_;

	local $/ = undef;
	if (! -f $file) { return undef; }
	open (F, "<$file");
	my $data = <F>;
	my $hash = md5_hex($data);
	close F;

	return $hash;
}	

