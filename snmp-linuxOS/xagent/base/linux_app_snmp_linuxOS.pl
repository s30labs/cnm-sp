#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_app_snmp_linuxOS.pl
#
# DESCRIPTION:
# Obtains linux OS info by SNMP. (CPU)
#
# CALLING SAMPLE:
# linux_app_snmp_linuxOS.pl -n ip
#
# INPUT (PARAMS):
# a. Host IP
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

#---------------------------------------------------------------------------
# linux_app_snmp_linuxOS.pl
#---------------------------------------------------------------------------
#---------------------------------------------------------------------------
use lib '/opt/crawler/bin/';
use strict;
use Time::Local;
use Crawler::SNMP;
use ONMConfig;
use Data::Dumper;
use JSON;

#---------------------------------------------------------------------------
my %SNMPCFGCMD=();
my $FILE_CONF='/cfg/onm.conf';

#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
linux_app_snmp_linuxOS.pl. $VERSION

$fpth[$#fpth] -n IP  [-o verbose]
$fpth[$#fpth] -h  : Ayuda

-n           IP/Host
-f verbose   Verbose Mode
USAGE

#-------------------------------------------------------------------------------------------
my $rcfgbase=conf_base($FILE_CONF);
my $STORE_PATH='/opt/data/rrd/';
my $data_path=$rcfgbase->{'data_path'}->[0];
my $log_level='debug';
my $snmp=Crawler::SNMP->new(store_path=>$STORE_PATH, cfg=>$rcfgbase, log_level=>$log_level, data_path=>$data_path);
my $store=$snmp->create_store();
my $dbh=$store->open_db();
$snmp->dbh($dbh);
$store->dbh($dbh);


# -v version [-c comunity] [-u sec_name -l sec_level -a auth_proto -A auth_pass -x priv_proto -X priv_pass] -n host
# getopts("v:c:u:l:a:A:x:X:n:h:w:f:o:z:M:i",\%opts);
$snmp->get_command_options(\%SNMPCFGCMD);
my $VERBOSE = ($SNMPCFGCMD{'descriptor'} eq 'verbose') ? 1 : 0;

my $credentials=$snmp->get_snmp_credentials({'ip'=>$SNMPCFGCMD{'host_ip'}});
my %SNMPCFG=(%SNMPCFGCMD, %$credentials);
if ($VERBOSE) { print Dumper (\%SNMPCFG); } 

my ($sysUpTime,$num_cores,$cpu_avg)=('',0,0);
my @DATA_LIST = ();
if ($SNMPCFG{'version'} <= 2) {
	my $v = ($SNMPCFG{'version'} == 2) ? '2c' : $SNMPCFG{'version'};
	my $cmd = "snmpwalk -v $v -c $SNMPCFG{'community'} $SNMPCFGCMD{'host_ip'} hrProcessorLoad";
	if ($VERBOSE) {  print "$cmd\n"; }
	my @res = `$cmd`;
	foreach my $l (@res) {
		chomp;
		if ($l=~/INTEGER:\s*(\d+)/) { 
			$num_cores += 1;
			$cpu_avg += $1; 
		}
	}
	$cpu_avg /= $num_cores;
	$cpu_avg = sprintf("%.4f",$cpu_avg);

	$cmd = "snmpget -v $v -c $SNMPCFG{'community'} $SNMPCFGCMD{'host_ip'} SNMPv2-MIB::sysUpTime.0";
	if ($VERBOSE) {  print "$cmd\n"; }
   my $x = `$cmd`;
	if ($x=~/Timeticks\: \(\d+\)\s*(.+)?/) { $sysUpTime = $1; }

	my %d=('ip'=>$SNMPCFGCMD{'host_ip'}, 'sysUpTime'=>$sysUpTime, 'num_cores'=>$num_cores, 'cpu_avg'=>$cpu_avg);
	push @DATA_LIST,\%d;
}

if ($VERBOSE) { print "$SNMPCFGCMD{'host_ip'} | sysUpTime=$sysUpTime | num_cores=$num_cores | cpu_avg=$cpu_avg\n"; }

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my @COL_MAP = (
#   { 'label'=>'IP', 'width'=>'16' , 'name_col'=>'ip',  'sort'=>'ipaddr', 'align'=>'left', 'filter'=>'#select_filter' },
   { 'label'=>'Up Time', 'width'=>'25' , 'name_col'=>'sysUpTime',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'Number of Cores', 'width'=>'20' , 'name_col'=>'num_cores',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   { 'label'=>'CPU Average', 'width'=>'20' , 'name_col'=>'cpu_avg',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
);

my $data=encode_json(\@DATA_LIST);
print "$data\n";

my $col_map=encode_json(\@COL_MAP);
print "$col_map\n";

exit 0;


#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
#if ($FORMAT eq 'json') {
#----------------------------------------------------------------------------

#   my $data=encode_json(\@host_data);
#   print "$data\n";

#	my @COL_MAP = ();
#	my $i=0;
#	foreach my $c (@LABELS) {
#		# OJO!!!! $LABELS[0]='IID'
#		if ($c eq 'IID') {
#			push @COL_MAP, {'label'=>$c, 'width'=>$MAX_IID_SIZE , 'name_col'=>$c,  'sort'=>'str', 'align'=>'left', 'filter'=>'#text_filter' };
#		}
#		else {
#			my $filter = $CONF->{'col'}->{$i}->{'filter'} || '#text_filter';
#			my $sort = $CONF->{'col'}->{$i}->{'sort'} || 'str';
#			my $align = $CONF->{'col'}->{$i}->{'align'} || 'left';
#			my $width = $CONF->{'col'}->{$i}->{'width'} || '10';
#			$width =~ s/\%//g;
#
#			push @COL_MAP, {'label'=>$c, 'width'=>$width , 'name_col'=>$c,  'sort'=>$sort, 'align'=>$align, 'filter'=>$filter };
#			$i+=1;
#		}
#	}
#   my $col_map=encode_json(\@COL_MAP);
#   print "$col_map\n";
#}

