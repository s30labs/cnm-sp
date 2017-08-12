#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_metric_wmi_perfOS.pl
#
# DESCRIPTION:
# Obtiene valores de los contadores WMI de un equipo WIndows remoto
#
# CALLING SAMPLE:
# lnux_metric_wmi_perfOS.pl -n 1.1.1.1 -d dominio -u user -p pwd  [-v]
# linux_metric_wmi_perfOS.pl -h  : Ayuda
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
use CNMScripts::WMI;

#--------------------------------------------------------------------------------------
my $counters;


#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
linux_metric_wmi_perfOS.pl $VERSION

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

my $domain='';
if ($user=~/(\S+)\/(\S+)/) { $user = $1; $domain = $2; }

my $wmi = CNMScripts::WMI->new('host'=>$ip, 'user'=>$user, 'pwd'=>$pwd, 'domain'=>$domain);

#--------------------------------------------------------------------------------------
# Estas dos lineas son importantes de cara a mejorar la eficiencia de las metricas
# 10 => Sin conectividad WMI con el equipo.
#--------------------------------------------------------------------------------------
my $ok=$wmi->check_tcp_port($ip,'135',5);
if (! $ok) { $wmi->host_status($ip,10);}


#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
$counters = $wmi->get_wmi_counters("'SELECT * FROM Win32_PerfFormattedData_PerfOS_Cache'");
#print Dumper ($counters);

$wmi->print_counter_value($counters, '001', 'AsyncCopyReadsPersec');
$wmi->print_counter_value($counters, '002', 'AsyncDataMapsPersec');
$wmi->print_counter_value($counters, '003', 'AsyncFastReadsPersec');
$wmi->print_counter_value($counters, '004', 'AsyncMDLReadsPersec');
$wmi->print_counter_value($counters, '005', 'AsyncPinReadsPersec');
$wmi->print_counter_value($counters, '006', 'CopyReadHitsPercent');
$wmi->print_counter_value($counters, '007', 'CopyReadHitsPercent_Base');
$wmi->print_counter_value($counters, '008', 'CopyReadsPersec');
$wmi->print_counter_value($counters, '009', 'DataFlushesPersec');
$wmi->print_counter_value($counters, '010', 'DataFlushPagesPersec');
$wmi->print_counter_value($counters, '011', 'DataMapHitsPercent');
$wmi->print_counter_value($counters, '012', 'DataMapHitsPercent_Base');
$wmi->print_counter_value($counters, '013', 'DataMapPinsPersec');
$wmi->print_counter_value($counters, '014', 'DataMapPinsPersec_Base');
$wmi->print_counter_value($counters, '015', 'DataMapsPersec');
$wmi->print_counter_value($counters, '016', 'FastReadNotPossiblesPersec');
$wmi->print_counter_value($counters, '017', 'FastReadResourceMissesPersec');
$wmi->print_counter_value($counters, '018', 'FastReadsPersec');
$wmi->print_counter_value($counters, '019', 'LazyWriteFlushesPersec');
$wmi->print_counter_value($counters, '020', 'LazyWritePagesPersec');
$wmi->print_counter_value($counters, '021', 'MDLReadHitsPercent');
$wmi->print_counter_value($counters, '022', 'MDLReadHitsPercent_Base');
$wmi->print_counter_value($counters, '023', 'MDLReadsPersec');
$wmi->print_counter_value($counters, '024', 'PinReadHitsPercent');
$wmi->print_counter_value($counters, '025', 'PinReadHitsPercent_Base');
$wmi->print_counter_value($counters, '026', 'PinReadsPersec');
$wmi->print_counter_value($counters, '027', 'ReadAheadsPersec');
$wmi->print_counter_value($counters, '028', 'SyncCopyReadsPersec');
$wmi->print_counter_value($counters, '029', 'SyncDataMapsPersec');
$wmi->print_counter_value($counters, '030', 'SyncFastReadsPersec');
$wmi->print_counter_value($counters, '031', 'SyncMDLReadsPersec');
$wmi->print_counter_value($counters, '032', 'SyncPinReadsPersec');

#if ($wmi->err_num() > 0) { 
#	print STDERR '**ERROR** '.$wmi->err_str()."\n";
#	exit;
#}


#--------------------------------------------------------------------------------------
$counters = $wmi->get_wmi_counters("'SELECT * FROM Win32_PerfFormattedData_PerfOS_Memory'");
#print Dumper ($counters);
$wmi->print_counter_value($counters, '101', 'AvailableBytes');
$wmi->print_counter_value($counters, '102', 'AvailableKBytes');
$wmi->print_counter_value($counters, '103', 'AvailableMBytes');
$wmi->print_counter_value($counters, '104', 'CacheBytes');
$wmi->print_counter_value($counters, '105', 'CacheBytesPeak');
$wmi->print_counter_value($counters, '106', 'CacheFaultsPersec');
$wmi->print_counter_value($counters, '107', 'CommitLimit');
$wmi->print_counter_value($counters, '108', 'CommittedBytes');
$wmi->print_counter_value($counters, '109', 'DemandZeroFaultsPersec');
$wmi->print_counter_value($counters, '110', 'FreeSystemPageTableEntries');
$wmi->print_counter_value($counters, '111', 'PageFaultsPersec');
$wmi->print_counter_value($counters, '112', 'PageReadsPersec');
$wmi->print_counter_value($counters, '113', 'PagesInputPersec');
$wmi->print_counter_value($counters, '114', 'PagesOutputPersec');
$wmi->print_counter_value($counters, '115', 'PagesPersec');
$wmi->print_counter_value($counters, '116', 'PageWritesPersec');
$wmi->print_counter_value($counters, '117', 'PercentCommittedBytesInUse');
$wmi->print_counter_value($counters, '118', 'PercentCommittedBytesInUse_Base');
$wmi->print_counter_value($counters, '119', 'PoolNonpagedAllocs');
$wmi->print_counter_value($counters, '120', 'PoolNonpagedBytes');
$wmi->print_counter_value($counters, '121', 'PoolPagedAllocs');
$wmi->print_counter_value($counters, '122', 'PoolPagedBytes');
$wmi->print_counter_value($counters, '123', 'PoolPagedResidentBytes');
$wmi->print_counter_value($counters, '124', 'SystemCacheResidentBytes');
$wmi->print_counter_value($counters, '125', 'SystemCodeResidentBytes');
$wmi->print_counter_value($counters, '126', 'SystemCodeTotalBytes');
$wmi->print_counter_value($counters, '127', 'SystemDriverResidentBytes');
$wmi->print_counter_value($counters, '128', 'SystemDriverTotalBytes');
$wmi->print_counter_value($counters, '129', 'WriteCopiesPersec');


#--------------------------------------------------------------------------------------
#$counters = $wmi->get_wmi_counters("'SELECT * FROM Win32_PerfFormattedData_PerfOS_Objects'");
##print Dumper ($counters);
#$wmi->print_counter_value($counters, '180', 'Events');
#$wmi->print_counter_value($counters, '181', 'Mutexes');
#$wmi->print_counter_value($counters, '182', 'Processes');
#$wmi->print_counter_value($counters, '183', 'Sections');
#$wmi->print_counter_value($counters, '184', 'Semaphores');
#$wmi->print_counter_value($counters, '185', 'Threads');


#--------------------------------------------------------------------------------------
$counters = $wmi->get_wmi_counters("\"SELECT * FROM Win32_PerfFormattedData_PerfOS_Processor WHERE Name='_Total'\"");
#print Dumper ($counters);
$wmi->print_counter_value($counters, '190', 'InterruptsPersec');
$wmi->print_counter_value($counters, '191', 'PercentIdleTime');
$wmi->print_counter_value($counters, '192', 'PercentInterruptTime');
$wmi->print_counter_value($counters, '193', 'PercentPrivilegedTime');
$wmi->print_counter_value($counters, '194', 'PercentProcessorTime');
$wmi->print_counter_value($counters, '195', 'PercentUserTime');


#--------------------------------------------------------------------------------------
$counters = $wmi->get_wmi_counters("\"SELECT * FROM Win32_PerfFormattedData_PerfOS_PagingFile WHERE Name='_Total'\"");
#print Dumper ($counters);
$wmi->print_counter_value($counters, '150', 'PercentUsage');
$wmi->print_counter_value($counters, '151', 'PercentUsagePeak');

#--------------------------------------------------------------------------------------
$counters = $wmi->get_wmi_counters("\"SELECT * FROM Win32_PerfFormattedData_PerfOS_System\"");
#print Dumper ($counters);

$wmi->print_counter_value($counters, '200', 'AlignmentFixupsPersec');
$wmi->print_counter_value($counters, '201', 'ContextSwitchesPersec');
$wmi->print_counter_value($counters, '202', 'ExceptionDispatchesPersec');
$wmi->print_counter_value($counters, '203', 'FileControlBytesPersec');
$wmi->print_counter_value($counters, '204', 'FileControlOperationsPersec');
$wmi->print_counter_value($counters, '205', 'FileDataOperationsPersec');
$wmi->print_counter_value($counters, '206', 'FileReadBytesPersec');
$wmi->print_counter_value($counters, '207', 'FileReadOperationsPersec');
$wmi->print_counter_value($counters, '208', 'FileWriteBytesPersec');
$wmi->print_counter_value($counters, '209', 'FileWriteOperationsPersec');
$wmi->print_counter_value($counters, '210', 'FloatingEmulationsPersec');
$wmi->print_counter_value($counters, '211', 'PercentRegistryQuotaInUse');
$wmi->print_counter_value($counters, '212', 'PercentRegistryQuotaInUse_Base');
$wmi->print_counter_value($counters, '213', 'Processes');
$wmi->print_counter_value($counters, '214', 'ProcessorQueueLength');
$wmi->print_counter_value($counters, '215', 'SystemCallsPersec');
$wmi->print_counter_value($counters, '216', 'SystemUpTime');
$wmi->print_counter_value($counters, '217', 'Threads');

