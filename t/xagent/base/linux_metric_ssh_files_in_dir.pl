#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_metric_ssh_files_in_dir.pl
#
# DESCRIPTION:
# Obtiene el numero de ficheros que existen en un determinado directorio.
#
# CALLING SAMPLE:
# linux_metric_ssh_files_in_dir.pl -n 1.1.1.1 -d /opt [-a pattern] [-v]
# linux_metric_ssh_files_in_dir.pl -n 1.1.1.1 -u user -p pwd -d /opt [-a pattern] [-v]
# linux_metric_ssh_files_in_dir.pl -n 1.1.1.1 -u user -k -p passphrase -d /opt [-a pattern] [-v]
# linux_metric_ssh_files_in_dir.pl -h  : Ayuda
#
# INPUT (PARAMS):
# a. -n  :  IP remota
# b. -d  :  Ruta del directorio
# c. -a  :  Patron de busqueda en el directorio
# d. -u  :  Usuario (ssh)
# e. -k	:	Usa autenticacion por clave publica
# f. -p  :  Clave|Passphrase (ssh)
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

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
ssh2cmd. $VERSION

$fpth[$#fpth] -n IP -d dir [-a pattern] [-w xml] [-v]
$fpth[$#fpth] -n IP -u user -p pwd -d dir [-a pattern] [-w xml] [-v]
$fpth[$#fpth] -n IP -u user -k -p passphrase -d dir [-a pattern] [-w xml] [-v]
$fpth[$#fpth] -h  : Ayuda

-n		IP remota/local
-u		user
-k		Indica si usa clave autenticacion por clave publica
-p		pwd
-k 	(Usa autenticacion basada en PK)
-d 	Directorio
-a		Patron de busqueda para los ficheros
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
my ($ip,$PK,$dir,$pattern,$FORMAT,$VERBOSE)=('',undef,'','.','txt',0);

#--------------------------------------------------------------------------------------
my %opts=();
getopts("hvn:u:p:c:w:d:a:f:k",\%opts);

if ($opts{h}) { die $USAGE;}
$ip=$opts{n} || die $USAGE;
$dir=$opts{d} || die $USAGE;

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
# SE PROCESA EL COMANDO
#--------------------------------------------------------------------------------------
my $CMD1 = <<END1;
/bin/ls $dir | /bin/grep $pattern | /usr/bin/wc -l
END1
#--------------------------------------------------------------------------------------

my @cmds=($CMD1);
my ($stdout, $stderr, $exit) = ('', '', 0);
my $ssh;

if (! $local) { 
  	$ssh = Net::OpenSSH->new($ip, %SSH_OPTS);
  	$ssh->error and die "Can't ssh to $ip: " . $ssh->error;
}

foreach my $cmd (@cmds) {

	verbose("CMD=$cmd");

	if (! $local) {
		($stdout, $stderr) = $ssh->capture2($cmd);
	}
	else { 
		$stdout = `$cmd`;
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

