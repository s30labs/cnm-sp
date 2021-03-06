#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_metric_wmi_process.pl
#
# DESCRIPTION:
# Obtiene informacion sobre el numero de procesos que se ejecutan en una maquina Win32
#
# CALLING SAMPLE:
# linux_metric_wmi_process.pl -n 1.1.1.1 -d dominio -u user -p pwd  [-v]
# linux_metric_wmi_process.pl -h  : Ayuda
#
# INPUT (PARAMS):
# a. -n  :  IP remota
# b. -d  :  Dominio
# c. -u  :  Usuario WMI
# d. -p  :  Clave
# e. -i  :  Nombre dedl proceso buscado 
#
# OUTPUT (STDOUT):
# <001.taskhostex.exe> Number of Processes = 2
# <001.vmtoolsd.exe> Number of Processes = 1
# <001.wininit.exe> Number of Processes = 1
# <001.winlogon.exe> Number of Processes = 3
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
use CNMScripts::WMI;

#--------------------------------------------------------------------------------------
my $counters;

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
linux_metric_wmi_process.pl $VERSION

$fpth[$#fpth] -n IP -u user -p pwd [-d domain]
$fpth[$#fpth] -n IP -u domain/user -p pwd
$fpth[$#fpth] -h  : Ayuda

-n    IP remota
-u    user
-p    pwd
-d    Dominio
-i    Nombre del proceso buscado
-v    Verbose
USAGE

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my %opts=();
getopts("hvn:u:p:i:d:",\%opts);

if ($opts{h}) { die $USAGE;}
my $ip = $opts{n} || die $USAGE;
my $user = $opts{u} || die $USAGE;
my $pwd = $opts{p} || die $USAGE;

my $VERBOSE = (exists $opts{v}) ? 1 : 0;
if ($opts{v}) { $VERBOSE=1; }

my $proc_searched='';
if (exists $opts{i}) {$proc_searched = $opts{i}; }

my $domain='';
#domain/user
if ($user=~/(\S+)\/(\S+)/) { $user = $2; $domain = $1; }

my $wmi = CNMScripts::WMI->new('host'=>$ip, 'user'=>$user, 'pwd'=>$pwd, 'domain'=>$domain);

#--------------------------------------------------------------------------------------
# Estas dos lineas son importantes de cara a mejorar la eficiencia de las metricas
# 10 => Sin conectividad WMI con el equipo.
#--------------------------------------------------------------------------------------
my ($ok,$lapse)=$wmi->check_tcp_port($ip,'135',5);
if (! $ok) { $wmi->host_status($ip,10);}

if ($VERBOSE) { print "check_tcp_port 135 in host $ip >> ok=$ok\n"; }
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
$counters = $wmi->get_wmi_counters("'SELECT * FROM Win32_Process'");
if ($VERBOSE) { print Dumper ($counters); }

#          {
#            'QuotaPeakPagedPoolUsage' => '212',
#            'HandleCount' => '313',
#            'OSName' => 'Microsoft Windows Server 2012 R2 Standard|C:\\Windows|\\Device\\Harddisk0\\Partition2',
#            'PeakVirtualSize' => '108576768',
#            'CreationClassName' => 'Win32_Process',
#            'Handle' => '4080',
#            'OSCreationClassName' => 'Win32_OperatingSystem',
#            'QuotaPeakNonPagedPoolUsage' => '24',
#            'PageFileUsage' => '5280',
#            'SessionId' => '5',
#            'ThreadCount' => '7',
#            'QuotaPagedPoolUsage' => '205',
#            'Caption' => 'UpdaterUI.exe',
#            'PeakWorkingSetSize' => '13100',
#            'CommandLine' => '"C:\\Program Files\\McAfee\\Agent\\x86\\UpdaterUI.exe" /StartedFromRunKey',
#            'ReadOperationCount' => '18567',
#            'Priority' => '8',
#            'Name' => 'UpdaterUI.exe',
#            'WindowsVersion' => '6.3.9600',
#            'PrivatePageCount' => '5406720',
#            'TerminationDate' => '(null)',
#            'Status' => '(null)',
#            'CSName' => 'PRO-PIE-APP-01',
#            'WorkingSetSize' => '8077312',
#            'Description' => 'UpdaterUI.exe',
#            'CreationDate' => '20200617155547.681328+120',
#            'CSCreationClassName' => 'Win32_ComputerSystem',
#            'ProcessId' => '4080',
#            'ParentProcessId' => '2744',
#            'UserModeTime' => '34375000',
#            'MaximumWorkingSetSize' => '1380',
#            'WriteOperationCount' => '53098',
#            'QuotaNonPagedPoolUsage' => '23',
#            'WriteTransferCount' => '5483640',
#            'OtherOperationCount' => '68244',
#            'VirtualSize' => '105451520',
#            'ExecutionState' => '0',
#            'InstallDate' => '(null)',
#            'MinimumWorkingSetSize' => '200',
#            'PageFaults' => '67701',
#            'KernelModeTime' => '48281250',
#            'PeakPageFileUsage' => '5540',
#            'ReadTransferCount' => '10936314',
#            'ExecutablePath' => 'C:\\Program Files\\McAfee\\Agent\\x86\\UpdaterUI.exe',
#            'OtherTransferCount' => '699316'
#          },

my %PROCESS_COUNT=();
foreach my $h (@$counters) {
	my $n = $h->{'Name'};
	if (! exists $PROCESS_COUNT{$n}) { $PROCESS_COUNT{$n} = 1; }
	else { $PROCESS_COUNT{$n} += 1; }
}

my $found=0;
my $txt = "Number of Processes";
foreach my $k (sort keys %PROCESS_COUNT) {

	if ($proc_searched eq $k) { $found=1; }
	my $tag = '001.'.$k;
	$wmi->test_init($tag,$txt);
	$wmi->test_done($tag,$PROCESS_COUNT{$k});
}

if (! $found) {
	my $tag = '001.'.$proc_searched;
	$wmi->test_init($tag,$txt);
	$wmi->test_done($tag,0);
}
$wmi->print_metric_data();

exit 0;


#$wmi->print_counter_value($counters, 'ProcessId', 'ProcessId');
#$wmi->print_counter_value($counters, 'DisconnectedSessions', 'DisconnectedSessions');
#$wmi->print_counter_value($counters, 'TotalSessions', 'TotalSessions');

