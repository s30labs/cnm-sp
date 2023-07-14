#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_app_ssh_script.pl
#
# DESCRIPTION:
# Ejecuta un script en un host remoto mediante SSH 
#
# CALLING SAMPLE:
# linux_app_ssh_script.pl -n 1.1.1.1 -d /opt [-a pattern] [-v]
# linux_app_ssh_script.pl -n 1.1.1.1 -u user -p pwd -d /opt [-a pattern] [-v]
# linux_app_ssh_script.pl -n 1.1.1.1 -u user -k -p passphrase -d /opt [-a pattern] [-v]
# linux_app_ssh_script.pl -h  : Ayuda
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
use CNMScripts::SSH;
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
$fpth[$#fpth] -n IP -s script -a "params..." -c '-user=aaa -pwd=bbb' [-w xml] [-v]
$fpth[$#fpth] -h  : Ayuda

-n		IP remota/local
-s		Fichero con el script
-a 	Parametros del script
-c		Credenciales SSH
-w		Formato de salida (xml|txt)
-v		Verbose
USAGE

#--------------------------------------------------------------------------------------
my $local_ip = my_ip();
my $local=0;
my ($PK,$dir,$pattern,$FORMAT,$VERBOSE)=(undef,'','.','txt',0);

#--------------------------------------------------------------------------------------
my %opts=();
getopts("hvn:c:w:a:s:",\%opts);

if ($opts{h}) { die $USAGE;}
my $ip=$opts{n} || die $USAGE;

my $script=$opts{s} || die $USAGE;
my $params=$opts{a} || '';

if (! -f $script) { die "No existe el fichero $script\n"; }

if ($opts{a}) { $pattern=$opts{a}; }

if ( ($ip eq 'localhost') || ($ip eq '127.0.0.1') || ($ip eq $local_ip) ) { $local=1; }

my $credentials = $opts{c} || die $USAGE;

if ($opts{w}) { $FORMAT='xml'; }
if ($opts{v}) { $VERBOSE=1; }


#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my ($stdout, $stderr, $exit) = ('', '', 0);
my $ssh;
my $t0 = [gettimeofday];
my $elapsed=0;
my $remote;


$SIG{CHLD} = 'IGNORE';

while (1) {

if (! $local) { 
   $remote = CNMScripts::SSH->new( 'host'=>$ip, 'credentials'=>$credentials );
#	my $logfile='/var/log/messages';
#	my $parser='syslog';
#	my $params="-f $logfile -t $parser";
   my $script1 = '/opt/crawler/bin/libexec/linux_log_parser.pl';
   my $remote = CNMScripts::SSH->new( 'host'=>$ip, 'credentials'=>$credentials );
   ($stdout, $stderr) = $remote->execute($script1,$params);
}

else { 
	$stdout = `$script $params`;
}

chomp $stdout;

if ($FORMAT eq 'txt') {
	
	verbose($stdout);
	print "****STDOUT****\n$stdout\n";
	if ($stderr ne '') {
  		print STDERR "*******stderr*****\n$stderr\n";
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




sleep 10;
}

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

