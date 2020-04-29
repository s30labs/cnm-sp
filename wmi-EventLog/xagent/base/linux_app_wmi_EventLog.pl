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
linux_app_wmi_EventLog.pl $VERSION

$fpth[$#fpth] -n IP -u user -p pwd [-d domain] [-i index]
$fpth[$#fpth] -n IP -u domain/user -p pwd [-d domain] [-i index]
$fpth[$#fpth] -h  : Ayuda

-n    IP remota
-u    user
-p    pwd
-d    Dominio
-i    Indice de busqueda. Valor del campo RecordNumber a pertir del cual se obtienen los datos
-h    Ayuda
-v    Verbose
USAGE

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my %opts=();
getopts("hvn:u:p:d:i:",\%opts);

if ($opts{h}) { die $USAGE;}
my $ip = $opts{n} || die $USAGE;
my $user = $opts{u} || die $USAGE;
my $pwd = $opts{p} || die $USAGE;
my $domain='';
#domain/user
if ($user=~/(\S+)\/(\S+)/) { $user = $2; $domain = $1; }

my $condition='';
if (($opts{i}) && ($opts{i}=~/\d+/)) { $condition= "AND RecordNumber>$opts{i}"; }

my $wmi = CNMScripts::WMI->new('host'=>$ip, 'user'=>$user, 'pwd'=>$pwd, 'domain'=>$domain);

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
my $ok=$wmi->check_tcp_port($ip,'135',5);
if ($ok) { 
	$lines = $wmi->get_wmi_lines("'SELECT * from Win32_NTLogEvent Where Logfile = \"System\" $condition'");
}

#print Dumper ($lines);

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
