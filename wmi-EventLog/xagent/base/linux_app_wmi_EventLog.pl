#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_app_wmi_EventLog.pl
#
# DESCRIPTION:
# Obtiene valores de los contadores WMI de un equipo WIndows remoto
#
# CALLING SAMPLE:
# linux_app_wmi_EventLog.pl -n 1.1.1.1 [-d dominio] -u user -p pwd  [-v]
# linux_app_wmi_EventLog.pl -h  : Ayuda
#
# INPUT (PARAMS):
# a. -n  :  IP remota
# b. -d  :  Dominio
# c. -u  :  Usuario WMI
# d. -p  :  Clave
# e. -i  :  Indice de busqueda. (Habitualmente Lgfile)
# f. -f  :  Filtro de busqueda
# g. -m  :  Max number of records
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
linux_app_wmi_EventLog.pl $VERSION

$fpth[$#fpth] -n IP -u user -p pwd [-d domain] [-i index]
$fpth[$#fpth] -n IP -u domain/user -p pwd [-d domain] [-i index]
$fpth[$#fpth] -h  : Ayuda

-n    IP remota
-u    user
-p    pwd
-d    Dominio
-i    Indice de busqueda. (Habitualmente Lgfile)
-f 	Filtro de busqueda
-m 	Max number of records
-h    Ayuda
-v    Verbose
USAGE

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my %opts=();
getopts("hvn:u:p:d:i:f:m:",\%opts);

if ($opts{h}) { die $USAGE;}
my $ip = $opts{n} || die $USAGE;
my $user = $opts{u} || die $USAGE;
my $pwd = $opts{p} || die $USAGE;
my $domain='';
#domain/user
if ($user=~/(\S+)\/(\S+)/) { $user = $2; $domain = $1; }

my $VERBOSE = (exists $opts{v}) ? 1 : 0;

my $condition='';
if (($opts{m}) && ($opts{m}=~/\d+/)) { $condition= " AND RecordNumber>$opts{m}"; }

my $property_index = 'Logfile';
if (exists $opts{i}) {$property_index = $opts{i}; }
my $property_value = 'System';
if (exists $opts{f}) {$property_value = $opts{f}; }



my $wmi = CNMScripts::WMIc->new('host'=>$ip, 'user'=>$user, 'pwd'=>$pwd, 'domain'=>$domain);

#--------------------------------------------------------------------------------------
my @COL_MAP = (
   { 'label'=>'RecordNumber', 'width'=>'6' , 'name_col'=>'RecordNumber',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'EventCode', 'width'=>'6' , 'name_col'=>'EventCode',  'sort'=>'ipaddr', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'ComputerName', 'width'=>'12' , 'name_col'=>'ComputerName',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   { 'label'=>'Type', 'width'=>'10' , 'name_col'=>'Type',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'SourceName', 'width'=>'10' , 'name_col'=>'SourceName',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   { 'label'=>'Message', 'width'=>'30' , 'name_col'=>'Message',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   { 'label'=>'EventType', 'width'=>'5' , 'name_col'=>'EventType',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'Logfile', 'width'=>'5' , 'name_col'=>'Logfile',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'TimeGenerated', 'width'=>'15' , 'name_col'=>'TimeGenerated',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'TimeWritten', 'width'=>'15' , 'name_col'=>'TimeWritten',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
);

#--------------------------------------------------------------------------------------
my ($ok,$lapse) = $wmi->check_tcp_port($ip,'135',3);

#--------------------------------------------------------------------------------------
my $container_dir_in_host = '/opt/containers/impacket';
my $wsql_file = 'app_Win32_NTLogEvent.wsql';
my $wsql_query = "SELECT RecordNumber,EventCode,Type,SourceName,Message,EventType,Logfile,TimeGenerated,TimeWritten FROM Win32_NTLogEvent";
if ($property_value ne '') {
   my $prefix = $property_value;
   $prefix =~ s/\s//g;
   $wsql_file = join('_',$prefix,$wsql_file);
   $wsql_query .= " WHERE $property_index='$property_value'";
}
if ($condition ne '') { $wsql_file = join('_',$condition,$wsql_file); }

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

# | RecordNumber | Logfile | EventIdentifier | EventCode | SourceName | Type | Category | CategoryString | TimeGenerated | TimeWritten | ComputerName | User | Message | InsertionStrings | Data | EventType |
#
#| 1144866 | System | 1073748860 | 7036 | Service Control Manager | Information | 0 | None | 20230426084618.643956-000 | 20230426084618.643956-000 | PRO-ETPAERO-APP.areas.net | None | The WMI Performance Adapter service entered the running state. | WMI Performance Adapter running  | 119 0 109 0 105 0 65 0 112 0 83 0 114 0 118 0 47 0 52 0 0 0  | 3 |


#--------------------------------------------------------------------------------------
if ($ok) { 
	#$lines = $wmi->get_wmi_lines("'SELECT * from Win32_NTLogEvent Where Logfile = \"System\" $condition'");
	$lines = $wmi->get_wmi_counters($wsql_file, 'RecordNumber');
}

if ($VERBOSE) { print "check_tcp_port 135 in host $ip >> ok=$ok\n"; }
if ($VERBOSE) { print Dumper ($lines); }

exit;
#if (ref($lines) eq "ARRAY") {
#	foreach my $l (@$lines) {
#		print '-'x60 . "\n";
#		print 'RecordNumber = '.$l->{'RecordNumber'}."\n";
#		print 'EventCode = '.$l->{'EventCode'}."\n";
#		print 'ComputerName = '.$l->{'ComputerName'}."\n";
#		print 'Type = '.$l->{'Type'}."\n";
#		print 'SourceName = '.$l->{'SourceName'}."\n";
#		print 'Message = '.$l->{'Message'}."\n";
#		print 'EventType = '.$l->{'EventType'}."\n";
#		print 'Logfile = '.$l->{'Logfile'}."\n";
#		#print 'TimeGenerated = '.$l->{'TimeGenerated'}."\n";
#		#print 'TimeWritten = '.$l->{'TimeWritten'}."\n";
#		print 'TimeGenerated = '.$wmi->date_format($l->{'TimeGenerated'})."\n";
#		print 'TimeWritten = '.$wmi->date_format($l->{'TimeWritten'})."\n";
#
#   }
#}

my $x=0;
if (ref($lines) eq "ARRAY") {
  	foreach my $l (@$lines) {

print "CNT=$x\n";
print Dumper($l)."\n";
$x+=1;

		$l->{'EventType'}= $wmi->event_type($l->{'EventType'});
		$l->{'TimeGenerated'}=$wmi->date_format($l->{'TimeGenerated'});
		$l->{'TimeWritten'}=$wmi->date_format($l->{'TimeWritten'});
	}
}

my $data=encode_json($lines);
print "$data\n";

my $col_map=encode_json(\@COL_MAP);
print "$col_map\n";

#--------------------------------------------------------------------------------------
