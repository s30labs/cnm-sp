#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_metric_wmi_base.pl
#
# DESCRIPTION:
# Obtiene valores de los contadores WMI de un equipo WIndows remoto
#
# CALLING SAMPLE:
# linux_metric_wmi_base.pl -n 1.1.1.1 -d dominio -u user -p pwd  [-v]
# linux_metric_wmi_base.pl -h  : Ayuda
#
# INPUT (PARAMS):
# a. -n  :  IP remota
# b. -d  :  Dominio
# c. -u  :  Usuario WMI
# d. -p  :  Clave
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
ssh2cmd. $VERSION

$fpth[$#fpth] -n IP -u user -p pwd -d domain [-v]
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

my $wmi = CNMScripts::WMI->new('host'=>$ip, 'user'=>$user, 'pwd'=>$pwd);

#--------------------------------------------------------------------------------------
# Estas dos lineas son importantes de cara a mejorar la eficiencia de las metricas
# 10 => Sin conectividad WMI con el equipo.
#--------------------------------------------------------------------------------------
my ($ok,$lapse) = $wmi->check_tcp_port($ip,'135',5);
if (! $ok) { $wmi->host_status($ip,10);}

#--------------------------------------------------------------------------------------
$counters = $wmi->get_wmi_counters("'SELECT * FROM Win32_ComputerSystem'");
$wmi->print_counter_value($counters, '001', 'NumberOfProcessors');
$wmi->print_counter_value($counters, '002', 'NumberOfLogicalProcessors');
$wmi->print_counter_value($counters, '003', 'TotalPhysicalMemory');
$wmi->print_counter_value($counters, '004', 'PowerState');
$wmi->print_counter_value($counters, '005', 'LastBootUpTime');
$wmi->print_counter_value($counters, '006', 'LocalDateTime');

#PowerState
#0 (0x0) Unknown
#1 (0x1) Full Power
#2 (0x2) Power Save - Low Power Mode
#3 (0x3) Power Save - Standby
#4 (0x4) Power Save - Unknown
#5 (0x5) Power Cycle
#6 (0x6) Power Off
#7 (0x7) Power Save - Warning
 
#--------------------------------------------------------------------------------------
$counters = $wmi->get_wmi_counters("'SELECT * FROM Win32_OperatingSystem'");
$wmi->print_counter_value($counters, '100', 'TotalVisibleMemorySize');
$wmi->print_counter_value($counters, '101', 'TotalVirtualMemorySize');
$wmi->print_counter_value($counters, '102', 'FreeVirtualMemory');
$wmi->print_counter_value($counters, '103', 'FreePhysicalMemory');
$wmi->print_counter_value($counters, '104', 'FreeSpaceInPagingFiles');
$wmi->print_counter_value($counters, '105', 'MaxNumberOfProcesses');
$wmi->print_counter_value($counters, '106', 'SizeStoredInPagingFiles');
$wmi->print_counter_value($counters, '107', 'NumberOfProcesses');
$wmi->print_counter_value($counters, '108', 'NumberOfUsers');

#--------------------------------------------------------------------------------------
$counters = $wmi->get_wmi_counters("'SELECT * FROM Win32_Processor'", 'DeviceID');
$wmi->print_counter_value($counters, '200', 'CurrentClockSpeed'); #MHz
$wmi->print_counter_value($counters, '201', 'LoadPercentage'); 
$wmi->print_counter_value($counters, '202', 'CurrentVoltage'); #x10

#--------------------------------------------------------------------------------------
$counters = $wmi->get_wmi_counters("'SELECT * FROM Win32_LogicalDisk'",'DeviceID');
$wmi->print_counter_value($counters, '300', 'Size');
$wmi->print_counter_value($counters, '301', 'FreeSpace');

#--------------------------------------------------------------------------------------
$counters = $wmi->get_wmi_counters("'SELECT * FROM Win32_PnPEntity WHERE ConfigManagerErrorCode <> 0'", 'PNPDeviceID');
my $n = scalar (keys %$counters);
print "<400> DevicesWithErrors = $n\n";


