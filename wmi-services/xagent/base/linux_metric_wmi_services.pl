#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_metric_wmi_services.pl
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
# e. -c  :  Clase wmi
# f. -i  :  Indice (iid) para la Clase wmi (Si aplica)
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
use CNMScripts::WMI;

#--------------------------------------------------------------------------------------
my $counters;

#--------------------------------------------------------------------------------------
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
my %opts=();
getopts("hvn:u:p:d:c:i:",\%opts);

if ($opts{h}) { die $USAGE;}
my $ip = $opts{n} || die $USAGE;
my $user = $opts{u} || die $USAGE;
my $pwd = $opts{p} || die $USAGE;
my $domain = '';
if (exists $opts{d}) { $domain = $opts{d}; }
if ($user=~/(\S+)\/(\S+)/) { $user = $2; $domain = $1; }
elsif ($user=~/(\S+)\\(\S+)/) { $user = $2; $domain = $1; }

#print "user=$user domain=$domain\n";

my $property_index = 'Name';
if (exists $opts{i}) {$property_index = $opts{i}; }

my $wmi = CNMScripts::WMI->new('host'=>$ip, 'user'=>$user, 'pwd'=>$pwd, 'domain'=>$domain);

#--------------------------------------------------------------------------------------
# Estas dos lineas son importantes de cara a mejorar la eficiencia de las metricas
# 10 => Sin conectividad WMI con el equipo.
#--------------------------------------------------------------------------------------
my $ok=$wmi->check_tcp_port($ip,'135',5);
if (! $ok) { $wmi->host_status($ip,10);}

#--------------------------------------------------------------------------------------
#http://msdn.microsoft.com/en-us/library/aa394418(v=vs.85).aspx
#class Win32_Service : Win32_BaseService
#{
#  boolean  AcceptPause;
#  boolean  AcceptStop;
#  string   Caption;
#  uint32   CheckPoint;
#  string   CreationClassName;
#  string   Description;
#  boolean  DesktopInteract;
#  string   DisplayName;
#  string   ErrorControl;
#  uint32   ExitCode;
#  datetime InstallDate;
#  string   Name;
#  string   PathName;
#  uint32   ProcessId;
#  uint32   ServiceSpecificExitCode;
#  string   ServiceType;
#  boolean  Started;
#  string   StartMode;
#  string   StartName;
#  string   State;
#  string   Status;
#  string   SystemCreationClassName;
#  string   SystemName;
#  uint32   TagId;
#  uint32   WaitHint;
#};
#--------------------------------------------------------------------------------------

$counters = $wmi->get_wmi_counters("'SELECT * FROM Win32_Service'", $property_index);

my %STATE_TABLE = (
	"Running" => 1,
	"Unknown"=>2,
	"Stopped" => 3,
	"Start Pending" => 4,
	"Stop Pending"=>5,
	"Continue Pending"=>6,
	"Pause Pending"=>7,
	"Paused"=>8,
);

$wmi->print_counter_value($counters, '200', 'State', \%STATE_TABLE);


