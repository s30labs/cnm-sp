#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_metric_wmi_event_viewer.pl
#
# DESCRIPTION:
# Obtiene valores de los contadores WMI de un equipo WIndows relativos al Visor de Eventos
#
# CALLING SAMPLE:
# linux_metric_wmi_event_viewer.pl -n 1.1.1.1 -d dominio -u user -p pwd  [-v]
# linux_metric_wmi_event_viewer.pl -h  : Ayuda
#
# INPUT (PARAMS):
# a. -n  :  IP remota
# b. -d  :  Dominio
# c. -u  :  Usuario WMI
# d. -p  :  Clave
#
# OUTPUT (STDOUT):
# <001> InUseCount = 0
# <002> FileSize = 524288
# <003> NumberOfRecords = 2514
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

#--------------------------------------------------------------------------------------
my $counters;


#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
linux_metric_wmi_event_viewer.pl $VERSION

$fpth[$#fpth] -n IP -u user -p pwd -d domain
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

my $domain='';
if ($user=~/(\S+)\/(\S+)/) { $user = $1; $domain = $2; }

my $wmi = CNMScripts::WMI->new('host'=>$ip, 'user'=>$user, 'pwd'=>$pwd, 'domain'=>$domain);

#--------------------------------------------------------------------------------------
# Estas dos lineas son importantes de cara a mejorar la eficiencia de las metricas
# 10 => Sin conectividad WMI con el equipo.
#--------------------------------------------------------------------------------------
my $ok=$wmi->check_tcp_port($ip,'135',5);
if (! $ok) { $wmi->host_status($ip,10);}


#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
$counters = $wmi->get_wmi_counters("\"SELECT * FROM Win32_NTEventLogFile WHERE  LogFileName='System'\"");
$wmi->print_counter_value($counters, '001', 'InUseCount');
$wmi->print_counter_value($counters, '002', 'FileSize');
$wmi->print_counter_value($counters, '003', 'NumberOfRecords');

