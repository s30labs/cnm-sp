#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_metric_wmi_services.pl
#
# DESCRIPTION:
# Service Status monitor using WMI
#
# CALLING SAMPLE:
# linux_metric_wmi_services.pl -n 1.1.1.1 -d dominio -u user -p pwd  [-v]
# linux_metric_wmi_services.pl -h  : Help
#
# INPUT (PARAMS):
# a. -n  :  Remote IP
# b. -d  :  Domain
# c. -u  :  WMI User
# d. -p  :  User Password
# e. -i  :  Index of the WMI Class (Win32_Service). Usually used Name
# f. -f  :  Filter used in the WSQL Query (If not used returns all services state). Is the ServiceName.
#
# OUTPUT (STDOUT):
# With Filter: (-f MyService)
# <200.MyService> State = 3
# Without Filter: (all services)
# <200.ALG> State = 3
# <200.AeLookupSvc> State = 3
# <200.AppIDSvc> State = 3
# <200.AppMgmt> State = 3
# <200.Appinfo> State = 1
# ...
#
# In case of socket connection error. If filter is used returns Unknown Status
# In case of socket connection error. If no filter is used returns nothing
# In case of WMI error. Returns nothing.
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
$fpth[$#fpth] -h  : Help

-n    Remote IP
-u    WMI User
-p    WMI User password
-d    Domain
-i    Index of the WMI Class (Win32_Service). Usually used Name
-f    Filter used in the WSQL Query (If not used returns all services state). Is the ServiceName.
-h    Help 
-v    Verbose mode

$fpth[$#fpth] -n 1.1.1.1 -u user -p xxx
$fpth[$#fpth] -n 1.1.1.1 -u user -p xxx -d myDomain
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
if ($VERBOSE) {
   $wmi->log_mode(3);
   $wmi->log_level('debug');
}

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
	if ($property_value ne '') { 
		$counters = { $property_value => { 'Name' => $property_value, 'State' => 'Unknown'} };
	}
}
else {
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
	#--------------------------------------------------------------------------------------
	my $container_dir_in_host = '/opt/containers/impacket';
	my $wsql_file = 'Win32_Service.wsql';
	my $wsql_query = 'SELECT Name,State FROM Win32_Service';
	if ($property_value ne '') { 
		my $prefix = $property_value;
		$prefix =~ s/\s//g;
		$wsql_file = join('_',$prefix,'Win32_Service.wsql'); 
		$wsql_query = "SELECT Name,State FROM Win32_Service WHERE $property_index='$property_value'";
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
	#$counters = $wmi->get_wmi_counters("'SELECT * FROM Win32_Service'", $property_index);
	$counters = $wmi->get_wmi_counters($wsql_file, $property_index);
}

if ($VERBOSE) { print Dumper($counters); }

$wmi->print_counter_value($counters, '200', 'State', \%STATE_TABLE);

my $tdiff = time()-$ts;
if ($VERBOSE) { 
	print "TDIFF = $tdiff sec.\n"; 
	if ($wmi->err_num()>0) { print 'ERROR: ['.$wmi->err_num().'] '.$wmi->err_str(). "\n"; }
}

