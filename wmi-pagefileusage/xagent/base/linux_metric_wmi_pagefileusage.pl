#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_metric_wmi_pagefileusage.pl
#
# DESCRIPTION:
# Obtiene valores de los contadores WMI de un equipo WIndows remoto
#
# CALLING SAMPLE:
# linux_metric_wmi_services.pl -n 1.1.1.1 -d dominio -u user -p pwd  [-v]
# linux_metric_wmi_services.pl -h  : Ayuda
#
# INPUT (PARAMS):
# a. -n  :  IP remota
# b. -d  :  Dominio
# c. -u  :  Usuario WMI
# d. -p  :  Clave
# e. -i  :  Indice (iid) para la Clase wmi (en este caso en Name)
# f. -f  :  Filtro sobre la consulta WSQL aplicado sobre el indice
#
# OUTPUT (STDOUT):
# <200.ALG> State = 3
# <200.AeLookupSvc> State = 3
# <200.AppIDSvc> State = 3
# <200.AppMgmt> State = 3
# <200.Appinfo> State = 1
# ...
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
my $CONTAINER_NAME = (exists $ENV{'CNM_TAG_CALLER'}) ? $ENV{'CNM_TAG_CALLER'} : '';

#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
linux_metric_wmi_services.pl $VERSION

$fpth[$#fpth] -n IP -u user -p pwd [-d domain] [-i Name]
$fpth[$#fpth] -n IP -u domain/user -p pwd [-i Name]
$fpth[$#fpth] -h  : Ayuda

-n    IP remota
-u    user
-p    pwd
-d    Dominio
-i    Index Propiedad para indexar las instancias. Por defecto es Name.
-f    Filtro para la query WSQL sobre index 
-h    Ayuda
-v    Verbose

$fpth[$#fpth] -n 1.1.1.1 -u user -p xxx
$fpth[$#fpth] -n 1.1.1.1 -u user -p xxx -d miDominio
$fpth[$#fpth] -n 1.1.1.1 -u user -p xxx -i Name
USAGE

#--------------------------------------------------------------------------------------
# Win32_ComputerSystem
# Win32_OperatingSystem
# Win32_CDROMDrive
# Win32_PCMCIAController
# Win32_PnPEntity
# Win32_PointingDevice
# Win32_Processor
# Win32_SystemEnclosure
# Win32_USBHub
# Win32_TapeDrive
# Win32_LogicalDisk
#--------------------------------------------------------------------------------------
my $ts=time();

my %opts=();
getopts("hvn:u:p:d:c:i:f:",\%opts);

if ($opts{h}) { die $USAGE;}
my $ip = $opts{n} || die $USAGE;
my $user = $opts{u} || die $USAGE;
my $pwd = $opts{p} || die $USAGE;
my $domain = '';
if (exists $opts{d}) { $domain = $opts{d}; }
if ($user=~/(\S+)\/(\S+)/) { $user = $2; $domain = $1; }
elsif ($user=~/(\S+)\\(\S+)/) { $user = $2; $domain = $1; }

my $VERBOSE = (exists $opts{v}) ? 1 : 0;
#print "user=$user domain=$domain\n";

my $property_index = 'Name';
if (exists $opts{i}) {$property_index = $opts{i}; }
my $property_value = '';
if (exists $opts{f}) {$property_value = $opts{f}; }

my $wmi = CNMScripts::WMIc->new('host'=>$ip, 'user'=>$user, 'pwd'=>$pwd, 'domain'=>$domain, 'container'=>$CONTAINER_NAME);

#--------------------------------------------------------------------------------------
# Estas dos lineas son importantes de cara a mejorar la eficiencia de las metricas
# 10 => Sin conectividad WMI con el equipo.
#--------------------------------------------------------------------------------------
my ($ok,$lapse)=$wmi->check_tcp_port($ip,'135',3);
if (! $ok) { $wmi->host_status($ip,10);}

if ($VERBOSE) { print "check_tcp_port 135 in host $ip >> ok=$ok\n"; }

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my $container_dir_in_host = '/opt/containers/impacket';
my $wsql_file = 'Win32_PageFileUsage.wsql';
my $wsql_query = 'SELECT Name,AllocatedBaseSize,CurrentUsage,PeakUsage FROM Win32_PageFileUsage';
if ($property_value ne '') { 
	my $prefix = lc $property_value;
	#C:\\pagefile.sys
	$prefix=~s/^(\w{1})\:\\.+/$1/g;
	$wsql_file = join('_',$prefix,'Win32_PageFileUsage.wsql'); 
	$wsql_query .= " WHERE $property_index='$property_value'";
}
my $wsql_file_path = join ('/', $container_dir_in_host, $wsql_file);
if (! -f $wsql_file_path) {
   open (F,">$wsql_file_path");
   print F "$wsql_query\n";
   close F;
}
if ($VERBOSE) { 
	print "wsql_file=$wsql_file\n";
	print "WSQL >> $wsql_query\n"; 
}
#--------------------------------------------------------------------------------------
#$counters = $wmi->get_wmi_counters("'SELECT * FROM Win32_Service'", $property_index);
$counters = $wmi->get_wmi_counters($wsql_file, $property_index);

my %new_counters=();
while (my ($k,$v) = each %$counters) {
	$k =~ s/^(\w{1})\:\\.+/$1/g;
	$k = uc $k;
	$new_counters{$k} = $v;
} 

if ($VERBOSE) { print Dumper($counters); }
if ($VERBOSE) { print Dumper(\%new_counters); }

$wmi->print_counter_value(\%new_counters, 'AllocatedBaseSize', 'AllocatedBaseSize');
$wmi->print_counter_value(\%new_counters, 'CurrentUsage', 'CurrentUsage');
$wmi->print_counter_value(\%new_counters, 'PeakUsage', 'PeakUsage');

my $tdiff = time()-$ts;
if ($VERBOSE) { print "tdiff = $tdiff sec.\n"; }



#$VAR1 = [
#          {
#            'Name' => 'C:\\pagefile.sys',
#            'CurrentUsage' => '188',
#            'AllocatedBaseSize' => '512',
#            'TempPageFile' => 'False',
#            'Caption' => 'C:\\pagefile.sys',
#            'Status' => '(null)',
#            'Description' => 'C:\\pagefile.sys',
#            'InstallDate' => '20140416091128.184826+120',
#            'PeakUsage' => '320'
#          },
#          {
#            'Name' => 'E:\\pagefile.sys',
#            'CurrentUsage' => '2072',
#            'Status' => '(null)',
#            'Description' => 'E:\\pagefile.sys',
#            'PeakUsage' => '2150',
#            'InstallDate' => '20160919121719.738989+120',
#            'AllocatedBaseSize' => '13312',
#            'TempPageFile' => 'False',
#           'Caption' => 'E:\\pagefile.sys'
#          }
#        ];

#foreach my $h (@$counters) {
#   my $iid = $h->{'Name'};
#   print "<240.$iid> AllocatedBaseSize = ".$h->{'AllocatedBaseSize'}."\n";
#   print "<241.$iid> CurrentUsage = ".$h->{'CurrentUsage'}."\n";
#   print "<242.$iid> PeakUsage = ".$h->{'PeakUsage'}."\n";
#}

