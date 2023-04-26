#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_metric_wmi_disk.pl
#
# DESCRIPTION:
# Obtiene valores de los contadores WMI de un equipo WIndows remoto
#
# CALLING SAMPLE:
# linux_metric_wmi_disk.pl -n 1.1.1.1 -d dominio -u user -p pwd  [-v]
# linux_metric_wmi_disk.pl -h  : Ayuda
#
# INPUT (PARAMS):
# a. -n  :  IP remota
# b. -d  :  Dominio
# c. -u  :  Usuario WMI
# d. -p  :  Clave
# e. -i  :  Indice (iid) para la Clase wmi (en este caso en Name)
# f. -f  :  Filtro sobre la consulta WSQL aplicado sobre el indice (Nombre del disco)
#
# OUTPUT (STDOUT):
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
linux_metric_wmi_disk.pl $VERSION

$fpth[$#fpth] -n IP -u user -p pwd [-d domain] [-i Name]
$fpth[$#fpth] -n IP -u domain/user -p pwd [-i Name]
$fpth[$#fpth] -h  : Ayuda

-n    IP remota
-u    user
-p    pwd
-d    Dominio
-i    Index Propiedad para indexar las instancias. Por defecto es Name. Otras opciones: PathName,DisplayName
-f    Filtro para la query WSQL sobre index
-v    Verbose

$fpth[$#fpth] -n 1.1.1.1 -u user -p xxx
$fpth[$#fpth] -n 1.1.1.1 -u user -p xxx -d miDominio
$fpth[$#fpth] -n 1.1.1.1 -u user -p xxx -i PathName
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
getopts("hvn:u:p:d:c:i:f:",\%opts);

if ($opts{h}) { die $USAGE;}
my $ip = $opts{n} || die $USAGE;
my $user = $opts{u} || die $USAGE;
my $pwd = $opts{p} || die $USAGE;
my $VERBOSE = (exists $opts{v}) ? 1 : 0;

my $domain='';
#domain/user
if ($user=~/(\S+)\/(\S+)/) { $user = $2; $domain = $1; }

my $property_index = 'Name';
if (exists $opts{i}) {$property_index = $opts{i}; }
my $property_value = '';
if (exists $opts{f}) {$property_value = $opts{f}; }

my $wmi = CNMScripts::WMIc->new('host'=>$ip, 'user'=>$user, 'pwd'=>$pwd, 'domain'=>$domain, 'container'=>$CONTAINER_NAME);

#--------------------------------------------------------------------------------------
# Estas dos lineas son importantes de cara a mejorar la eficiencia de las metricas
# 10 => Sin conectividad WMI con el equipo.
#--------------------------------------------------------------------------------------
my ($ok,$lapse)=$wmi->check_tcp_port($ip,'135',5);
if (! $ok) { $wmi->host_status($ip,10);}

if ($VERBOSE) { print "check_tcp_port 135 in host $ip >> ok=$ok\n"; }
#--------------------------------------------------------------------------------------
# http://msdn.microsoft.com/en-us/library/aa394173(v=vs.85).aspx
#class Win32_LogicalDisk : CIM_LogicalDisk
#{
#  uint16   Access;
#  uint16   Availability;
#  uint64   BlockSize;
#  string   Caption;
#  boolean  Compressed;
#  uint32   ConfigManagerErrorCode;
#  boolean  ConfigManagerUserConfig;
#  string   CreationClassName;
#  string   Description;
#  string   DeviceID;
#  uint32   DriveType;
#  boolean  ErrorCleared;
#  string   ErrorDescription;
#  string   ErrorMethodology;
#  string   FileSystem;
#  uint64   FreeSpace;
#  datetime InstallDate;
#  uint32   LastErrorCode;
#  uint32   MaximumComponentLength;
#  uint32   MediaType;
#  string   Name;
#  uint64   NumberOfBlocks;
#  string   PNPDeviceID;
#  uint16   PowerManagementCapabilities[];
#  boolean  PowerManagementSupported;
#  string   ProviderName;
#  string   Purpose;
#  boolean  QuotasDisabled;
#  boolean  QuotasIncomplete;
#  boolean  QuotasRebuilding;
#  uint64   Size;
#  string   Status;
#  uint16   StatusInfo;
#  boolean  SupportsDiskQuotas;
#  boolean  SupportsFileBasedCompression;
#  string   SystemCreationClassName;
#  string   SystemName;
#  boolean  VolumeDirty;
#  string   VolumeName;
#  string   VolumeSerialNumber;
#};
#
#--------------------------------------------------------------------------------------
# Obtiene datos de los discos logicos exceptuando los de tipo CD-Rom, DVD ...
#--------------------------------------------------------------------------------------
my $container_dir_in_host = '/opt/containers/impacket';
my $wsql_file = 'Win32_LogicalDisk.wsql';
my $wsql_query = 'SELECT Name,FreeSpace,Size,Availability,Status,DriveType,VolumeDirty FROM Win32_LogicalDisk WHERE DriveType!=5';
if ($property_value ne '') {
   my $prefix = $property_value;
   $prefix =~ s/\s//g;
   $prefix =~ s/\://g;
   $wsql_file = join('_',$prefix,'Win32_LogicalDisk.wsql');
   $wsql_query .= " AND $property_index='$property_value'";
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
$counters = $wmi->get_wmi_counters($wsql_file, $property_index);

if ($VERBOSE) { print Dumper($counters); }


my %AVAILABILITY_TABLE = (

	'1' => 'Other',
	'2' => 'Unknown',
	'3' => 'Running or Full Power',
	'4' => 'Warning',
	'5' => 'In Test',
	'6' => 'Not Applicable',
	'7' => 'Power Off',
 	'8' => 'Offline',
 	'9' => 'Off Duty',
 	'10' => 'Degraded',
	'11' => 'Not Installed',
 	'12' => 'Install Error',
 	'13' => 'Power Save - Unknown', #The device is known to be in a power save mode, but its exact status is unknown.
	'14' => 'Power Save - Low Power Mode', #The device is in a power save state, but still functioning, and may exhibit degraded performance.
	'15' => 'Power Save - Standby', #The device is not functioning, but could be brought to full power quickly.
 	'16' => 'Power Cycle',
 	'17' => 'Power Save - Warning', #The device is in a warning state, but also in a power save mode.
);

my %DRIVE_TYPES_TABLE = (
	'0' => 'Unknown',
 	'1' => 'No Root Directory',
 	'2' => 'Removable Disk',
 	'3' => 'Local Disk',
	'4' => 'Network Drive',
 	'5' => 'Compact Disc',
	'6' => 'RAM Disk',
);
 

my $r200 = $wmi->print_counter_value($counters, '200', 'FreeSpace', {});
my $r201 = $wmi->print_counter_value($counters, '201', 'Size', {});

#print Dumper($r200),"\n";
#$wmi->test_init('400','FreeSpace');
#$wmi->test_done('400',$r200);
#$wmi->print_metric_data();


# 202 DiskUsage
foreach my $iid (sort keys (%$r200)) {
	if ((exists $r201->{$iid}) && (exists $r200->{$iid})) {
		my $usage = $r201->{$iid}-$r200->{$iid};
		print "<202\.$iid> DiskUsage = $usage\n";
	}
}

# 203 DiskUsage(%)
foreach my $iid (sort keys (%$r200)) {
   if ((exists $r201->{$iid}) && (exists $r200->{$iid})) {
      my $usage = 0;
      if ($r201->{$iid} > 0) { $usage = (($r201->{$iid}-$r200->{$iid})/$r201->{$iid})*100; }
		
      print "<203\.$iid> DiskUsage(%) = ".sprintf("%.2f",$usage)."\n";
   }
}


$wmi->print_counter_value($counters, '204', 'Availability', \%AVAILABILITY_TABLE);
# Status -> SMART disks. Posibles valores:
# "OK","Error","Degraded","Unknown","Pred Fail","Starting","Stopping","Service","Stressed","NonRecover","No Contact","Lost Comm"
$wmi->print_counter_value($counters, '205', 'Status', {});
$wmi->print_counter_value($counters, '206', 'DriveType', \%DRIVE_TYPES_TABLE);
$wmi->print_counter_value($counters, '207', 'VolumeDirty', {}); #True/Flase


