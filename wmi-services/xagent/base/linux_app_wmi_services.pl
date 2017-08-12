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
use CNMScripts::WMI;
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
if ($user=~/(\S+)\/(\S+)/) { $user = $1; $domain = $2; }

my $wmi = CNMScripts::WMI->new('host'=>$ip, 'user'=>$user, 'pwd'=>$pwd, 'domain'=>$domain);
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
   { 'label'=>'Name', 'width'=>'12' , 'name_col'=>'Name',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'DisplayName', 'width'=>'12' , 'name_col'=>'DisplayName',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'PathName', 'width'=>'15' , 'name_col'=>'PathName',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'Description', 'width'=>'30' , 'name_col'=>'Description',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'ProcessId', 'width'=>'6' , 'name_col'=>'ProcessId',  'sort'=>'int', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'Started', 'width'=>'12' , 'name_col'=>'Started',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   { 'label'=>'State', 'width'=>'10' , 'name_col'=>'State',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   { 'label'=>'Status', 'width'=>'10' , 'name_col'=>'Status',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
);

#--------------------------------------------------------------------------------------
my $ok=$wmi->check_tcp_port($ip,'135',5);
if ($ok) { 
	$lines = $wmi->get_wmi_lines("'SELECT Name,DisplayName,PathName,Description,ProcessId,Started,State,Status FROM Win32_Service'");
}

#print Dumper ($lines);

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