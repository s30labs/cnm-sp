#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_app_wmi_class.pl
#
# DESCRIPTION:
# Obtiene valores de los contadores WMI de un equipo WIndows remoto
#
# CALLING SAMPLE:
# linux_app_wmi_class.pl -n 1.1.1.1 -d dominio -u user -p pwd -c Win32_Service  [-a root\CIMV2]
# linux_app_wmi_class.pl -h  : Ayuda
#
# INPUT (PARAMS):
# a. -n  :  IP remota
# b. -d  :  Dominio
# c. -u  :  Usuario WMI
# d. -p  :  Clave
# e. -c  :  Clase wmi
# f. -i  :  Indice (iid) para la Clase wmi (Si aplica)
# g. -a  :  Namespace (si es distinto de root\CIMV2)
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
use CNMScripts::WMI;

#--------------------------------------------------------------------------------------
my $counters;

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
linux_app_wmi_class.pl $VERSION

$fpth[$#fpth] -n IP -u user -p pwd [-d domain] -c class [-i index] [-a root\\CIMV2]
$fpth[$#fpth] -n IP -u domain/user -p pwd -c class [-i index]
$fpth[$#fpth] -h  : Ayuda

-n    IP remota
-u    user
-p    pwd
-d    Dominio
-v    Verbose
-c    Clase wmi (Win32_Service ...)
-i    Indice (iid) para la Clase wmi (Si aplica) 
-a		Namespace (si es distinto de root\\CIMV2)

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
getopts("hvn:u:p:d:c:i:a:",\%opts);

if ($opts{h}) { die $USAGE;}
my $ip = $opts{n} || die $USAGE;
my $user = $opts{u} || die $USAGE;
my $pwd = $opts{p} || die $USAGE;
my $class = $opts{c} || die $USAGE;
my $iid = (exists $opts{i}) ? $opts{i} : '';
my $namespace = (exists $opts{a}) ? $opts{a} : 'root\CIMV2';
my $domain='';
#domain/user
if ($user=~/(\S+)\/(\S+)/) { $user = $2; $domain = $1; }

my $wmi = CNMScripts::WMI->new('host'=>$ip, 'user'=>$user, 'pwd'=>$pwd, 'domain'=>$domain, 'namespace'=>$namespace);

#--------------------------------------------------------------------------------------
# Estas dos lineas son importantes de cara a mejorar la eficiencia de las metricas
# 10 => Sin conectividad WMI con el equipo.
#--------------------------------------------------------------------------------------
my $ok=$wmi->check_tcp_port($ip,'135',5);
if (! $ok) { $wmi->host_status($ip,10);}

#--------------------------------------------------------------------------------------
$counters = $wmi->get_wmi_counters("'SELECT * FROM $class'", $iid);
$wmi->print_counter_all($counters, $class);

