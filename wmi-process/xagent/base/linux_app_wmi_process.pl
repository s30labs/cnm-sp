#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_app_wmi_services.pl
#
# DESCRIPTION:
# Obtiene los datos relativos a los servicios definidos en un equipo WIndows remoto
#
# CALLING SAMPLE:
# linux_app_wmi_services.pl -n 1.1.1.1 [-d dominio] -u user -p pwd  [-v]
# linux_app_wmi_services.pl -h  : Ayuda
#
# INPUT (PARAMS):
# a. -n  :  IP remota
# b. -d  :  Dominio
# c. -u  :  Usuario WMI
# d. -p  :  Clave
#
# OUTPUT (STDOUT):
# Vector JSON con los datos
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
use JSON;

#--------------------------------------------------------------------------------------
my $lines=[];

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
linux_app_wmi_services.pl $VERSION

$fpth[$#fpth] -n IP -u user -p pwd [-d domain]
$fpth[$#fpth] -n IP -u domain/user -p pwd
$fpth[$#fpth] -h  : Ayuda

-n    IP remota
-u    user
-p    pwd
-d    Dominio
-h    Ayuda
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
#domain/user
if ($user=~/(\S+)\/(\S+)/) { $user = $2; $domain = $1; }

my $VERBOSE = (exists $opts{v}) ? 1 : 0;
my $wmi = CNMScripts::WMIc->new('host'=>$ip, 'user'=>$user, 'pwd'=>$pwd, 'domain'=>$domain);
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

#Name,DisplayName,PathName,Description,ProcessId,Started,State,Status
#--------------------------------------------------------------------------------------
my @COL_MAP = (
   { 'label'=>'Name', 'width'=>'15' , 'name_col'=>'Name',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'ProcessId', 'width'=>'10' , 'name_col'=>'ProcessId',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'Priority', 'width'=>'5' , 'name_col'=>'Priority',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'ThreadCount', 'width'=>'10' , 'name_col'=>'ThreadCount',  'sort'=>'int', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'CommandLine', 'width'=>'25' , 'name_col'=>'CommandLine',  'sort'=>'int', 'align'=>'left', 'filter'=>'#text_filter' },
);

#--------------------------------------------------------------------------------------
my ($ok,$lapse)=$wmi->check_tcp_port($ip,'135',3);

#--------------------------------------------------------------------------------------
my $container_dir_in_host = '/opt/containers/impacket';
my $wsql_file = 'app_Win32_Process.wsql';
my $wsql_file_path = join ('/', $container_dir_in_host, $wsql_file);
if (! -f $wsql_file_path) {
   open (F,">$wsql_file_path");
   print F "SELECT Name,ProcessId,Priority,ThreadCount,CommandLine FROM Win32_Process\n";
   #print F "SELECT Name,DisplayName,PathName,Description,ProcessId,Started,State,Status FROM Win32_Process\n";
   close F;
}


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


#--------------------------------------------------------------------------------------
if ($ok) { 
	$lines = $wmi->get_wmi_lines($wsql_file);
}

if ($VERBOSE) { print "check_tcp_port 135 in host $ip >> ok=$ok\n"; }
if ($VERBOSE) { print Dumper ($lines); }

#if (ref($lines) eq "ARRAY") {
#  	foreach my $l (@$lines) {
#
#		$l->{'EventType'}= $wmi->event_type($l->{'EventType'});
#		$l->{'TimeGenerated'}=$wmi->date_format($l->{'TimeGenerated'});
#		$l->{'TimeWritten'}=$wmi->date_format($l->{'TimeWritten'});
#	}
#}

my $data=encode_json($lines);
print "$data\n";

my $col_map=encode_json(\@COL_MAP);
print "$col_map\n";

#--------------------------------------------------------------------------------------
