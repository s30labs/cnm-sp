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
# e. -i  :  Indice (iid) para la Clase wmi (en este caso en Name)
# f. -f  :  Filtro sobre la consulta WSQL aplicado sobre el indice (el nombre del proceso)
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
linux_metric_wmi_process.pl $VERSION

$fpth[$#fpth] -n IP -u user -p pwd [-d domain]
$fpth[$#fpth] -n IP -u domain/user -p pwd
$fpth[$#fpth] -h  : Ayuda

-n    IP remota
-u    user
-p    pwd
-d    Dominio
-i    Index Propiedad para indexar las instancias. Por defecto es Name.
-f    Filtro para la query WSQL sobre index (el nombre del proceso buscado)
-v    Verbose
USAGE

#--------------------------------------------------------------------------------------
my $ts=time();

#--------------------------------------------------------------------------------------
my %opts=();
getopts("hvn:u:p:i:d:f:",\%opts);

if ($opts{h}) { die $USAGE;}
my $ip = $opts{n} || die $USAGE;
my $user = $opts{u} || die $USAGE;
my $pwd = $opts{p} || die $USAGE;

my $VERBOSE = (exists $opts{v}) ? 1 : 0;
if ($opts{v}) { $VERBOSE=1; }

my $proc_searched='';
#if (exists $opts{i}) {$proc_searched = $opts{i}; }

my $property_index = 'Name';
if (exists $opts{i}) {$property_index = $opts{i}; }
my $property_value = '';
if (exists $opts{f}) {$property_value = $opts{f}; }

my $domain='';
#domain/user
if ($user=~/(\S+)\/(\S+)/) { $user = $2; $domain = $1; }

my $wmi = CNMScripts::WMIc->new('host'=>$ip, 'user'=>$user, 'pwd'=>$pwd, 'domain'=>$domain, 'container'=>$CONTAINER_NAME);
if ($VERBOSE) {
   $wmi->log_mode(3);
   $wmi->log_level('debug');
}

#--------------------------------------------------------------------------------------
# Estas dos lineas son importantes de cara a mejorar la eficiencia de las metricas
# 10 => Sin conectividad WMI con el equipo.
#--------------------------------------------------------------------------------------
my ($ok,$lapse)=$wmi->check_tcp_port($ip,'135',3);
if ($VERBOSE) {
   if (! $ok) { print "check_tcp_port 135 in host $ip >> **ERROR**\n"; }
   else { print "check_tcp_port 135 in host $ip >> OK\n"; }
}

if (! $ok) { 
	$wmi->host_status($ip,10);
}
else {
	#--------------------------------------------------------------------------------------
	#https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-process
	my $container_dir_in_host = '/opt/containers/impacket';
	my $wsql_file = 'Win32_Process.wsql';
	#my $wsql_query = 'SELECT Name,ProcessId,ThreadCount,PageFaults,PageFileUsage,PeakPageFileUsage,PeakVirtualSize,VirtualSize,ReadTransferCount,WriteTransferCount,OtherTransferCount FROM Win32_Process';
	my $wsql_query = 'SELECT Name,ProcessId FROM Win32_Process';
	if ($property_value ne '') {
   	my $prefix = $property_value;
	   $prefix =~ s/\s//g;
   	$prefix =~ s/\./_/g;
	   $wsql_file = join('_',$prefix,'Win32_Process.wsql');
   	$wsql_query .= " WHERE $property_index='$property_value'";
	}
	my $wsql_file_path = join ('/', $container_dir_in_host, $wsql_file);
	if (! -f $wsql_file_path) {
   	open (F,">$wsql_file_path");
	   print F "$wsql_query\n";
   	close F;
	}
	if ($VERBOSE) {
   	print "wsql_file = $wsql_file\n";
   	print "WSQL >> $wsql_query\n";
	}
	#--------------------------------------------------------------------------------------
	$counters = $wmi->get_wmi_counters($wsql_file, 'ProcessId');
}

#--------------------------------------------------------------------------------------
if ($VERBOSE) { print Dumper ($counters); }

#          '6564' => {
#                      'Name' => 'explorer.exe',
#                      'ProcessId' => '6564'
#                    },
#          '936' => {
#                     'Name' => 'svchost.exe',
#                     'ProcessId' => '936'
#                   },

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
if ($wmi->err_num()==0) { $PROCESS_COUNT{$property_value} = 0; }

foreach my $k (keys %$counters) {
	# $k ==> PID
	my $n = $counters->{$k}->{'Name'};
	#my $n = $h->{'Name'};
	if (! exists $PROCESS_COUNT{$n}) { $PROCESS_COUNT{$n} = 1; }
	else { $PROCESS_COUNT{$n} += 1; }
}

my $found=0;
my $txt = "Number of Processes";
foreach my $k (sort keys %PROCESS_COUNT) {

	if ($property_value eq $k) { $found=1; }
	my $tag = '001.'.$k;
	$wmi->test_init($tag,$txt);
	$wmi->test_done($tag,$PROCESS_COUNT{$k});
}

if (($property_value ne '') && (! $found)) {
	my $tag = '001.'.$$property_value;
	$wmi->test_init($tag,$txt);
	$wmi->test_done($tag,0);
}
$wmi->print_metric_data();

my $tdiff = time()-$ts;
if ($VERBOSE) {
   print "TDIFF = $tdiff sec.\n";
   if ($wmi->err_num()>0) { print 'ERROR: ['.$wmi->err_num().'] '.$wmi->err_str(). "\n"; }
}

exit 0;

