#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_metric_wmi_RDSLicenses.pl
#
# DESCRIPTION:
# Obtiene informacion sobre las licencias asignadas en un servidor de licencias RDS
#
# CALLING SAMPLE:
# lnux_metric_wmi_RDSLicenses.pl -n 1.1.1.1 -d dominio -u user -p pwd  [-v]
# linux_metric_wmi_RDSLicenses.pl -h  : Ayuda
#
# INPUT (PARAMS):
# a. -n  :  IP remota
# b. -d  :  Dominio
# c. -u  :  Usuario WMI
# d. -p  :  Clave
#
# OUTPUT (STDOUT):
# <001> AsyncCopyReadsPersec = 0
# <002> AsyncDataMapsPersec = 0
# <003> AsyncFastReadsPersec = 0
# .....
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
use Data::Dumper;
use Stdout;
use CNMScripts::WMIc;

#--------------------------------------------------------------------------------------
my $counters;

#--------------------------------------------------------------------------------------
my $CONTAINER_NAME = (exists $ENV{'CNM_TAG_CALLER'}) ? $ENV{'CNM_TAG_CALLER'} : 'sh-'.int(1000*rand);

#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
linux_metric_wmi_RDSLicenses.pl $VERSION

$fpth[$#fpth] -n IP -u user -p pwd [-d domain]
$fpth[$#fpth] -n IP -u domain/user -p pwd
$fpth[$#fpth] -h  : Ayuda

-n    IP remota
-u    user
-p    pwd
-d    Dominio
-v    Verbose
USAGE

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my %opts=();
getopts("hvn:u:p:d:",\%opts);

if ($opts{h}) { die $USAGE;}
my $ip = $opts{n} || die $USAGE;
my $user = $opts{u} || die $USAGE;
my $pwd = $opts{p} || die $USAGE;

my $VERBOSE = (exists $opts{v}) ? 1 : 0;
if ($opts{v}) { $VERBOSE=1; }

my $domain='';
#domain/user
if ($user=~/(\S+)\/(\S+)/) { $user = $2; $domain = $1; }

my $wmi = CNMScripts::WMIc->new('host'=>$ip, 'user'=>$user, 'pwd'=>$pwd, 'domain'=>$domain, 'container'=>$CONTAINER_NAME);

#--------------------------------------------------------------------------------------
# Estas dos lineas son importantes de cara a mejorar la eficiencia de las metricas
# 10 => Sin conectividad WMI con el equipo.
#--------------------------------------------------------------------------------------
my ($ok,$lapse)=$wmi->check_tcp_port($ip,'135',5);
if (! $ok) { $wmi->host_status($ip,10);}

if ($VERBOSE) { print "check_tcp_port 135 in host $ip >> ok=$ok\n"; }

#--------------------------------------------------------------------------------------
my $ts=time();
#--------------------------------------------------------------------------------------
my $container_dir_in_host = '/opt/containers/impacket';
my $wsql_file = 'Win32_TSIssuedLicense.wsql';
my $wsql_file_path = join ('/', $container_dir_in_host, $wsql_file);
if (! -f $wsql_file_path) {
   open (F,">$wsql_file_path");
   print F "SELECT LicenseStatus,sIssuedToUser,sIssuedToComputer FROM Win32_TSIssuedLicense\n";
   close F;
}

#--------------------------------------------------------------------------------------
$counters = $wmi->get_wmi_counters($wsql_file);
if ($VERBOSE) { print Dumper ($counters); }

#{
#	'LicenseId' => '57',
#   'IssueDate' => '20200606044620.000000-000',
#   'sIssuedToUser' => 'areas-de.areas.com\\kastriot.caushllari',
#   'ExpirationDate' => '20200805044620.000000-000',
#   'KeyPackId' => '3',
#   'LicenseStatus' => '2',
#   'sIssuedToComputer' => ' ',
#   'sHardwareId' => '000000000000000000000000000000000000'
#},

my %LICENSE_STATUS = (
	'0' => 'UNK', #'The license status is unknown',
	'1' => 'TEMP', #'The license is a temporary license',
	'2' => 'ACTIVE', #'The license is active',
	'3' => 'UPGRADE', #'The license is an upgrade license',
	'4' => 'REVOKED', #'The license has been revoked',
	'5' => 'PENDING', #'The license status is pending',
	'6' => 'CONCURRENT', #'The license is a concurrent license'
);

my %LIC_BY_STATUS = ( '0'=> 0, '1'=>0, '2'=>0, '3'=>0, '4'=>0,  '5'=>0, '6'=>0 );
my %LIC_ACTIVE_BY_TYPE = ( 'total'=>0, 'sIssuedToComputer'=>0, 'sIssuedToUser'=>0 );
my ($total, $sIssuedToComputer, $sIssuedToUser) = (0,0,0);
foreach my $h (@$counters) {
	if ($h->{'LicenseStatus'} == 2) {
		$LIC_ACTIVE_BY_TYPE{'total'} += 1;
		if ($h->{'sIssuedToUser'} =~ /\w+/) { $LIC_ACTIVE_BY_TYPE{'sIssuedToUser'} += 1; }
		elsif ($h->{'sIssuedToComputer'} =~ /\w+/) { $LIC_ACTIVE_BY_TYPE{'sIssuedToComputer'} += 1; }
	}
	$LIC_BY_STATUS{$h->{'LicenseStatus'}} += 1;
}

foreach my $k (sort keys %LICENSE_STATUS) {
	my $tag = '001.'.$LICENSE_STATUS{$k};
	my $txt = "Number of licenses in $LICENSE_STATUS{$k} Status";
	$wmi->test_init($tag,$txt);
	$wmi->test_done($tag,$LIC_BY_STATUS{$k});
}

foreach my $k (sort keys %LIC_ACTIVE_BY_TYPE) {
   my $tag = '002.'.$k;
	my $txt = "Number of active licenses by type $k";
   $wmi->test_init($tag,$txt);
   $wmi->test_done($tag,$LIC_ACTIVE_BY_TYPE{$k});
}

$wmi->print_metric_data();

my $tdiff = time()-$ts;
if ($VERBOSE) { print "tdiff = $tdiff sec.\n"; }

exit 0;

