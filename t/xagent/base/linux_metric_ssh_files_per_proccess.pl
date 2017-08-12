#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:	linux_metric_ssh_files_per_proccess.pl
#
# DESCRIPTION:
# Obtiene el numero de ficheroa abiertos por un proceso determinado.
# Numero de metricas = 2
# Tiene instancias = SI
#
# CALLING SAMPLE:
# linux_metric_ssh_files_per_proccess.pl -n 1.1.1.1 -a apache  [-v]
# linux_metric_ssh_files_per_proccess.pl -n 1.1.1.1 -u user -p pwd -a apache [-v]
# linux_metric_ssh_files_per_proccess.pl -n 1.1.1.1 -u user -k -p passphrase -a apache [-v]
# linux_metric_ssh_files_per_proccess.pl -h  : Ayuda
#
# INPUT (PARAMS):
# a. -n	: 	IP remota
# b. -a	:	Nombre del proceso
# c. -u	:	Usuario (ssh)
# d. -k :	Usa autenticacion por clave publica
# d. -p	: 	Clave (ssh)
#
# OUTPUT (STDOUT):
# <001.apache2> Num, Proccess [apache2] = 6
# <001.arpwatch> Num, Proccess [arpwatch] = 1
# ....
# <002.apache2> Files opened [apache2] = 684
# <002.arpwatch> Files opened [arpwatch] = 12
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
my $CMD1 = <<END1;
/usr/bin/lsof | perl -lane '\$x{"\$F[0]:\$F[1]"}++; END { print "\$x{\$_}\t\$_\" for sort {\$x{\$a}<=>\$x{\$b}} keys \%x}' 
END1

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
ssh2cmd. $VERSION

$fpth[$#fpth] -n IP -a process_name [-w xml] [-v]
$fpth[$#fpth] -n IP -u user -p pwd [-w xml] [-v]
$fpth[$#fpth] -n IP -u user -k -p passphrase [-w xml] [-v]
$fpth[$#fpth] -h  : Ayuda

-n		IP remota/local
-u		user
-p		pwd
-k		(Usa autenticacion basada en PK)
-a		Nombre del proceso
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
my ($ip,$PK,$FORMAT,$VERBOSE)=('',undef,'txt',0);

#--------------------------------------------------------------------------------------
my %opts=();
getopts("hvn:u:p:c:w:a:",\%opts);

if ($opts{h}) { die $USAGE;}
$ip=$opts{n} || die $USAGE;

if ( ($ip eq 'localhost') || ($ip eq '127.0.0.1') || ($ip eq $local_ip) ) { $local=1; }
#print "local=$local\n";

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

	my @lines=split(/\n/,$stdout);
	my $total=0;
#57      slapd:1492
#60      nmbd:1545
#65      syslog-ng:25054

	my %NUM_FILES=();
	my %NUM_PROCS=();
	foreach my $l (@lines) {
		my ($nfiles,$name_pid) = split(/\s+/,$l);
		my ($name,$pid)=split(':',$name_pid);
		verbose("V=$nfiles");

		if (!exists $NUM_PROCS{$name}) { 
			$NUM_PROCS{$name}=1; 
			$NUM_FILES{$name}=$nfiles; 
		}
		else { 
         $NUM_PROCS{$name}+=1;
         $NUM_FILES{$name}+=$nfiles;
      }

	}

	if ($FORMAT eq 'txt') {
	
		verbose($stdout);

		foreach my $k (sort keys %NUM_PROCS) {
			print "<001.$k> Num, Proccess [$k] = $NUM_PROCS{$k}\n";
		}
      foreach my $k (sort keys %NUM_FILES) {
         print "<002.$k> Files opened [$k] = $NUM_FILES{$k}\n";
      }

		if ($exit != 0) {
   		print STDERR "stderr=$stderr\n";
   		print STDERR "exit=$exit\n";
			exit $exit;
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
   $r=~/inet\s+addr\:(\d+\.\d+\.\d+\.\d+)\s+/;
   return $1;
}

#--------------------------------------------------------------------------------------
sub verbose {
my ($msg)=@_;

	if ($VERBOSE) {print STDERR "$msg\n"; }
}

