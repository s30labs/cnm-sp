#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_metric_ssh_script.pl
#
# DESCRIPTION:
# Ejecuta un script en un host remoto mediante SSH 
#
# CALLING SAMPLE:
# linux_metric_ssh_script.pl -n 1.1.1.1 -d /opt [-a pattern] [-v]
# linux_metric_ssh_script.pl -n 1.1.1.1 -u user -p pwd -d /opt [-a pattern] [-v]
# linux_metric_ssh_script.pl -n 1.1.1.1 -u user -k -p passphrase -d /opt [-a pattern] [-v]
# linux_metric_ssh_script.pl -h  : Ayuda
#
# INPUT (PARAMS):
# -n  :  IP remota
# -u  :  Usuario (ssh)
# -k	:	Usa autenticacion por clave publica
# -p  :  Clave|Passphrase (ssh)
# -s  :  Fichero que contiene el script
# -a  :  Parametros del script
#
# OUTPUT (STDOUT):
# <001> Number of Files [/opt|.] = 7
#
# OUTPUT (STDERR):
# Error info, warnings etc... If verbose also debug info.
#
# EXIT CODE:
#  0: OK
# -1: System error
# >0: Script error
#--------------------------------------------------------------------------------------
use lib '/opt/crawler/bin/';
use strict;
use Getopt::Std;
use Net::OpenSSH;
use Stdout;
use Time::HiRes qw(gettimeofday tv_interval);

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
ssh2cmd. $VERSION

$fpth[$#fpth] -n IP -s script -a "params..." [-w xml] [-v]
$fpth[$#fpth] -n IP -u user -p pwd -s script -a "params..." [-w xml] [-v]
$fpth[$#fpth] -n IP -u user -k -p passphrase -s script -a "params..." [-w xml] [-v]
$fpth[$#fpth] -h  : Ayuda

-n		IP remota/local
-u		user
-k		Indica si usa clave autenticacion por clave publica
-p		pwd
-s		Fichero con el script
-a 	Parametros del script
-k 	(Usa autenticacion basada en PK)
-f		Fichero de claves 
-w		Formato de salida (xml|txt)
-v		Verbose
USAGE

#--------------------------------------------------------------------------------------
my %SSH_OPTS =(
   'port'   => 22,
	'master_opts' => [-o => "StrictHostKeyChecking=no"],
#   'user'   => '',
#   'password'  => '',
#   'passphrase'   =>'',
#   'key_path'  => ''

);

my $local_ip = my_ip();
my $local=0;
my ($ip,$PK,$dir,$pattern,$FORMAT,$VERBOSE,$script)=('',undef,'','.','txt',0,'');

#--------------------------------------------------------------------------------------
my %opts=();
getopts("hvn:u:p:c:w:a:f:s:k",\%opts);

if ($opts{h}) { die $USAGE;}
$ip=$opts{n} || die $USAGE;
$script=$opts{s} || die $USAGE;

if (! -f $script) { die "No existe el fichero $script\n"; }

if ($opts{a}) { $pattern=$opts{a}; }

if ( ($ip eq 'localhost') || ($ip eq '127.0.0.1') || ($ip eq $local_ip) ) { $local=1; }

if (! $local) {
	$SSH_OPTS{'user'} = $opts{u} || die $USAGE;
	if (exists $opts{k}) { 
		$PK=1;
		$SSH_OPTS{'passphrase'} = $opts{p};
		$SSH_OPTS{'key_path'} = (exists $opts{f}) ? $opts{f} : '/home/cnm/.ssh/id_rsa';
	}
	elsif (exists $opts{p}) {
		$SSH_OPTS{'password'} = $opts{p};
	}
	else {
		die $USAGE;
	}
}

if ($opts{w}) { $FORMAT='xml'; }
if ($opts{v}) { $VERBOSE=1; }


#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my ($stdout, $stderr, $exit) = ('', '', 0);
my $ssh;
my $t0 = [gettimeofday];
my $elapsed=0;

if (! $local) { 
  	$ssh = Net::OpenSSH->new($ip, %SSH_OPTS);
  	$ssh->error and die "Can't ssh to $ip: " . $ssh->error;
}


if (! $local) {

	my $rc = $ssh->scp_put($script,'/tmp');
	print "scp $script ---> remote res=$rc\n";
	($stdout, $stderr) = $ssh->capture2($script);
}
else { 
	$stdout = `$script`;
}

chomp $stdout;

if ($FORMAT eq 'txt') {
	
	verbose($stdout);
	print "<001> Number of Files [$dir|$pattern] = $stdout\n";
	if ($stderr ne '') {
  		print STDERR "stderr=$stderr\n";
		exit;
	}
}
else {


   my @COL_KEYS = (
  	   {'name_col'=>'descr', 'width'=>'60', 'sort'=>'str', 'align'=>'left', 'filter'=>'#text_filter'},
  	);

  	my %COL_MAP=('descr'=>'Description');


   my $ts=time;
  	my $TIMEDATE=time2date($ts);

  	my %results_vector=();
	my %line=('descr'=>$stdout);
  	$results_vector{$ip}=[\%line];

   my $xml = dumph2xml(\@COL_KEYS, \%COL_MAP, \%results_vector, $TIMEDATE);
  	print "$xml\n";

}

$elapsed = tv_interval ( $t0, [gettimeofday]);
my $elapsed3 = sprintf("%.6f", $elapsed);
print "DUR=$elapsed3\n";

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
# FUNCIONES AUXILIARES
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
sub time2date {
my ($ts)=@_;

   if (! $ts) { $ts=time(); }
   my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($ts);
   $year += 1900;
   $mon += 1;
   my $datef=sprintf("%02d/%02d/%02d %02d:%02d:%02d",$year,$mon,$mday,$hour,$min,$sec);
   #return  "$year-$mon-$mday  $hour:$min:$sec";
   return  $datef;
}

#--------------------------------------------------------------------------------------
sub my_ip {

   my $r=`/sbin/ifconfig eth0`;
   if ($r=~/inet\s+addr\:(\d+\.\d+\.\d+\.\d+)\s+/) { return $1; }
   elsif ($r=~/inet\s+(\d+\.\d+\.\d+\.\d+)\s+/) { return $1; }
   return '';
}

#--------------------------------------------------------------------------------------
sub verbose {
my ($msg)=@_;

	if ($VERBOSE) {print STDERR "$msg\n"; }
}

