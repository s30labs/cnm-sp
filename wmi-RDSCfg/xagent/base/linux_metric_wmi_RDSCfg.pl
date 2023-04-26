#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_metric_wmi_RDSCfg.pl
#
# DESCRIPTION:
# Obtiene valores de los contadores WMI de un equipo Windows de las clase de Remote Desktop Services Configuration
#
# CALLING SAMPLE:
# lnux_metric_wmi_RDSCfg.pl -n 1.1.1.1 -d dominio -u user -p pwd  [-v]
# linux_metric_wmi_RDSCfg.pl -h  : Ayuda
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
my $VERBOSE=0;

#--------------------------------------------------------------------------------------
my $CONTAINER_NAME = (exists $ENV{'CNM_TAG_CALLER'}) ? $ENV{'CNM_TAG_CALLER'} : 'sh-'.int(1000*rand);

#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
linux_metric_wmi_RDSCfg.pl $VERSION

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

if ($opts{v}) { $VERBOSE=1; }

my $domain='';
#domain/user
if ($user=~/(\S+)\/(\S+)/) { $user = $2; $domain = $1; }

#--------------------------------------------------------------------------------------
my $wmi = CNMScripts::WMIc->new('host'=>$ip, 'user'=>$user, 'pwd'=>$pwd, 'domain'=>$domain, 'container'=>$CONTAINER_NAME);

#--------------------------------------------------------------------------------------
# Estas dos lineas son importantes de cara a mejorar la eficiencia de las metricas
# 10 => Sin conectividad WMI con el equipo.
#--------------------------------------------------------------------------------------
my ($ok,$lapse) = $wmi->check_tcp_port($ip,'135',5);
if (! $ok) { $wmi->host_status($ip,10);}

if ($VERBOSE) { print "check_tcp_port 135 in host $ip >> ok=$ok\n"; }

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my $container_dir_in_host = '/opt/containers/impacket';
my $wsql_file = 'Win32_TerminalService.wsql';
my $wsql_file_path = join ('/', $container_dir_in_host, $wsql_file);
if (! -f $wsql_file_path) { 
	open (F,">$wsql_file_path");
	print F "SELECT * FROM Win32_TerminalService\n";
	close F;
}

#--------------------------------------------------------------------------------------
$counters = $wmi->get_wmi_counters($wsql_file);
if ($VERBOSE) { print Dumper ($counters); }

$wmi->print_counter_value($counters, 'ProcessId', 'ProcessId');
$wmi->print_counter_value($counters, 'DisconnectedSessions', 'DisconnectedSessions');
$wmi->print_counter_value($counters, 'TotalSessions', 'TotalSessions');

