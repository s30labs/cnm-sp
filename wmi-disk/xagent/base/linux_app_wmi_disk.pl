#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_app_wmi_disk.pl
#
# DESCRIPTION:
# Obtiene los datos relativos a los servicios definidos en un equipo Windows remoto
#
# CALLING SAMPLE:
# linux_app_wmi_disk.pl -n 1.1.1.1 [-d dominio] -u user -p pwd  [-v]
# linux_app_wmi_disk.pl -h  : Ayuda
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
linux_app_wmi_disk.pl $VERSION

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
my $VERBOSE = (exists $opts{v}) ? 1 : 0;

my $domain='';
#domain/user
if ($user=~/(\S+)\/(\S+)/) { $user = $2; $domain = $1; }

my $wmi = CNMScripts::WMIc->new('host'=>$ip, 'user'=>$user, 'pwd'=>$pwd, 'domain'=>$domain);

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
#--------------------------------------------------------------------------------------
my @COL_MAP = (
   { 'label'=>'Name', 'width'=>'12' , 'name_col'=>'Name',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'SystemName', 'width'=>'12' , 'name_col'=>'SystemName',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'Description', 'width'=>'30' , 'name_col'=>'Description',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'Size', 'width'=>'15' , 'name_col'=>'Size',  'sort'=>'int', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'FreeSpace', 'width'=>'15' , 'name_col'=>'FreeSpace',  'sort'=>'int', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'DriveType', 'width'=>'6' , 'name_col'=>'DriveType',  'sort'=>'int', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'VolumeSerialNumber', 'width'=>'12' , 'name_col'=>'VolumeSerialNumber',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   { 'label'=>'Availability', 'width'=>'10' , 'name_col'=>'Availability',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   { 'label'=>'VolumeDirty', 'width'=>'10' , 'name_col'=>'VolumeDirty',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
);

#--------------------------------------------------------------------------------------
my $container_dir_in_host = '/opt/containers/impacket';
my $wsql_file = 'app_Win32_LogicalDisk.wsql';
my $wsql_query = 'SELECT Name,SystemName,Description,Size,FreeSpace,DriveType,VolumeSerialNumber,Availability,VolumeDirty FROM Win32_LogicalDisk';
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
my ($ok,$lapse)=$wmi->check_tcp_port($ip,'135',5);
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
