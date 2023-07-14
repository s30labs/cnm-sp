#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_app_restore_passive_from_active.pl
#
# DESCRIPTION:
# Script para sincronizar un equipo pasivo a partir del backup de uno activo, que obtiene por SSH.
# Solo se ejecuta si el ro del equipo es Pasivo.
#
# CALLING SAMPLE:
# linux_app_restore_passive_from_active.pl -r 1.1.1.1 [-v]
#
# INPUT (PARAMS):
# a. -r  :  IP del equipo remoto
#
# OUTPUT (STDOUT):
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
use Data::Dumper;

#--------------------------------------------------------------------------------------
my $file_path_remote = '/home/cnm/backup/cnm_backup.tar';
my $dir_local_backup = '/home/cnm/backup/';

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
ssh2cmd. $VERSION

$fpth[$#fpth] -r IP -u user -p pwd [-v]
$fpth[$#fpth] -r IP -c [-v]

-r		IP del equipo remoto. Si no se especifica, se supone local. Se puede especificar ip:puerto
-c		Solo copia ficheros, no restaura. Por defecto copia y restaura.
-u		user
-p		pwd o passphrase si se especifica -k.
-k 	Usa autenticacion basada en PK
-w		Formato de salida (xml|txt)
-v		Verbose
USAGE

#--------------------------------------------------------------------------------------
my %SSH_OPTS =(
   'port'   => 22,
	'master_opts' => [-o => "StrictHostKeyChecking=no"],
   'user'   => 'cnm',
   'password'  => 'cnm123',
#   'passphrase'   =>'',
#   'key_path'  => ''

);

my $local=1;
my ($ip,$PK,$FORMAT,$VERBOSE)=('',undef,'txt',0);

#--------------------------------------------------------------------------------------
my $role_info = get_role_info();

print Dumper($role_info);

if (! exists $role_info->{'ROLE'}) { exit; }
if (lc $role_info->{'ROLE'}  ne 'passive') { exit; }

#--------------------------------------------------------------------------------------
my %opts=();
getopts("hvr:u:p:c:w:d:a:f:k",\%opts);

if ($opts{h}) { die $USAGE;}
if ($opts{v}) { $VERBOSE=1; }

if ($opts{r}) { 
	$local=0; 
	$ip=$opts{r};
	if ($opts{r}=~/(\d+\.\d+\.\d+\.\d+)\:(\d+)/) {
		$ip=$1;
		$SSH_OPTS{'port'}=$2;
	}	
}

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

	my $ssh = Net::OpenSSH->new($ip, %SSH_OPTS);
	$ssh->error and die "Can't ssh to $ip: " . $ssh->error;

	my $rc = $ssh->scp_get({copy_attrs => 1 }, $file_path_remote,$dir_local_backup);
	print "RC=$rc\n";

}


if (! $opts{c}) {
	# do_restore
	print "HAGO restore ...\n";
	`php /var/www/html/onm/apps/cnm_restore.php`;

	if (! $local) {
		print "SET ip scheme ...\n";
		my $ip=my_ip();
		`php /opt/cnm/update/db/update/update_scheme_ip.php ip=$ip`;
	}
}


#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
# FUNCIONES AUXILIARES
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
sub verbose {
my ($msg)=@_;

	if ($VERBOSE) {print STDERR "$msg\n"; }
}

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
sub my_ip {

   my $r=`/sbin/ifconfig eth0`;
   if ($r=~/inet\s+addr\:(\d+\.\d+\.\d+\.\d+)\s+/) { return $1; }
   elsif ($r=~/inet\s+(\d+\.\d+\.\d+\.\d+)\s+/) { return $1; }
   return '';
}

#-------------------------------------------------------------------------------------------------------
sub get_role_info {

	my %cfg=();
	my $file_role='/cfg/onm.role';
   open (F,"<$file_role");
   while (<F>) {

      chomp;
      if (/^#/) {next;}
      if (/^\s*(\S+)\s*\=\s*(.*?)\s*$/) { $cfg{$1}=$2; }
	}
	return \%cfg;
}
