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
my $VERBOSE = (exists $opts{v}) ? 1 : 0;

my $domain='';
#domain/user
if ($user=~/(\S+)\/(\S+)/) { $user = $2; $domain = $1; }

my $wmi = CNMScripts::WMIc->new('host'=>$ip, 'user'=>$user, 'pwd'=>$pwd, 'domain'=>$domain, 'container'=>$CONTAINER_NAME);

#--------------------------------------------------------------------------------------
# Estas dos lineas son importantes de cara a mejorar la eficiencia de las metricas
# 10 => Sin conectividad WMI con el equipo.
#--------------------------------------------------------------------------------------
my ($ok,$lapse) = $wmi->check_tcp_port($ip,'135',3);
if (! $ok) { $wmi->host_status($ip,10);}

if ($VERBOSE) { print "check_tcp_port 135 in host $ip >> ok=$ok\n"; }
#--------------------------------------------------------------------------------------

my $ts = time();
#--------------------------------------------------------------------------------------
my $container_dir_in_host = '/opt/containers/impacket';
my $wsql_file = 'Win32_perfOS.wsql';
my @wsql_query = ( 
	'SELECT AvailableBytes,PageFaultsPersec,PagesPersec FROM Win32_PerfFormattedData_PerfOS_Memory',
	'SELECT InterruptsPersec,PercentIdleTime,PercentInterruptTime,PercentPrivilegedTime,PercentProcessorTime,PercentUserTime FROM Win32_PerfFormattedData_PerfOS_Processor WHERE Name="_Total"',
	'SELECT Processes,ProcessorQueueLength,SystemCallsPersec,SystemUpTime,Threads FROM Win32_PerfFormattedData_PerfOS_System',
	'SELECT NumberOfProcessors,NumberOfLogicalProcessors,TotalPhysicalMemory FROM Win32_ComputerSystem',
);

my $wsql_file_path = join ('/', $container_dir_in_host, $wsql_file);
if (! -f $wsql_file_path) {
   open (F,">$wsql_file_path");
	foreach my $l (@wsql_query) {
   	print F "$l\n";
	}
   close F;
}
if ($VERBOSE) { 
	print "wsql_file_path = $wsql_file_path\n";
	foreach my $l (@wsql_query) {
		print "WSQL >> $l\n"; 
	}
}


#--------------------------------------------------------------------------------------
$counters = $wmi->get_wmi_counters($wsql_file, '');


#my @new_counters = (
#          {
#            'PercentProcessorTime' => '0',
#            'PercentUserTime' => '0',
#            'Processes' => '0',
#            'PagesPersec' => '0',
#            'PercentInterruptTime' => '0',
#            'SystemCallsPersec' => '0',
#            'PercentIdleTime' => '0',
#            'PageFaultsPersec' => '0',
#            'SystemUpTime' => '0',
#            'Threads' => '0',
#            'ProcessorQueueLength' => '0',
#            'PercentPrivilegedTime' => '0',
#            'AvailableBytes' => '0',
#            'InterruptsPersec' => '0',
#            'NumberOfLogicalProcessors' => '0',
#            'TotalPhysicalMemory' => '0',
#            'NumberOfProcessors' => '0'
#          }
#);




my %hcounters = ();
foreach my $h (@$counters) {
	while (my ($k,$v) = each(%$h) ) {  	$hcounters{$k} = $v; }
}

my @new_counters = ();
push @new_counters, \%hcounters;

if ($VERBOSE) { print Dumper(\@new_counters); }

$wmi->print_counter_value(\@new_counters, 'AvailableBytes', 'AvailableBytes');
$wmi->print_counter_value(\@new_counters, 'PageFaultsPersec', 'PageFaultsPersec');
$wmi->print_counter_value(\@new_counters, 'PagesPersec', 'PagesPersec');
$wmi->print_counter_value(\@new_counters, 'InterruptsPersec', 'InterruptsPersec');
$wmi->print_counter_value(\@new_counters, 'PercentIdleTime', 'PercentIdleTime');
$wmi->print_counter_value(\@new_counters, 'PercentInterruptTime', 'PercentInterruptTime');
$wmi->print_counter_value(\@new_counters, 'PercentPrivilegedTime', 'PercentPrivilegedTime');
$wmi->print_counter_value(\@new_counters, 'PercentProcessorTime', 'PercentProcessorTime');
$wmi->print_counter_value(\@new_counters, 'PercentUserTime', 'PercentUserTime');
$wmi->print_counter_value(\@new_counters, 'Processes', 'Processes');
$wmi->print_counter_value(\@new_counters, 'ProcessorQueueLength', 'ProcessorQueueLength');
$wmi->print_counter_value(\@new_counters, 'SystemCallsPersec', 'SystemCallsPersec');
$wmi->print_counter_value(\@new_counters, 'SystemUpTime', 'SystemUpTime');
$wmi->print_counter_value(\@new_counters, 'Threads', 'Threads');
$wmi->print_counter_value(\@new_counters, 'NumberOfProcessors', 'NumberOfProcessors');
$wmi->print_counter_value(\@new_counters, 'NumberOfLogicalProcessors', 'NumberOfLogicalProcessors');
$wmi->print_counter_value(\@new_counters, 'TotalPhysicalMemory', 'TotalPhysicalMemory');

my $tdiff = time()-$ts;
if ($VERBOSE) { print "tdiff = $tdiff sec.\n"; }

exit 0;

