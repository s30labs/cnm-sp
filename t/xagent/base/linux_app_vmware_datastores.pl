#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_metric_vmware_datastores.pl
#
# DESCRIPTION:
# Obtiene valores de los contadores WMI de un equipo WIndows remoto
#
# CALLING SAMPLE:
# linux_metric_vmware_datastores.pl -n 1.1.1.1 -d dominio -u user -p pwd  [-v]
# linux_metric_vmware_datastores.pl -h  : Ayuda
#
# INPUT (PARAMS):
# a. -n  :  IP remota
# b. -d  :  Dominio
# c. -u  :  Usuario WMI
# d. -p  :  Clave
# e. -c  :  Clase wmi
# f. -i  :  Indice (iid) para la Clase wmi (Si aplica)
#
# OUTPUT (STDOUT):
# <200.ALG> State = 3
# <200.AeLookupSvc> State = 3
# <200.AppIDSvc> State = 3
# <200.AppMgmt> State = 3
# <200.Appinfo> State = 1
# ...
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
use CNMScripts::vSphereSDK;

#--------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
linux_metric_vmware_datastores.pl $VERSION

$fpth[$#fpth] -n IP -u user -p pwd [-d domain] [-i Name]
$fpth[$#fpth] -n IP -u domain/user -p pwd [-i Name]
$fpth[$#fpth] -h  : Ayuda

-n    IP remota (server)
-u    user
-p    pwd
-P    port
-H    Host Name
-h    Ayuda
-v    Verbose

$fpth[$#fpth] -n 1.1.1.1 -u user -p xxx
$fpth[$#fpth] -n 1.1.1.1 -u user -p xxx -d miDominio
$fpth[$#fpth] -n 1.1.1.1 -u user -p xxx -i Name
USAGE

#--------------------------------------------------------------------------------------
my %opts=();
getopts("hvn:u:p:d:H:P:",\%opts);

if ($opts{h}) { die $USAGE;}
my $ip = $opts{n} || die $USAGE;
my $port = $opts{P} || '443';
my $user = $opts{u} || die $USAGE;
my $pwd = $opts{p} || die $USAGE;
#my $host = $opts{H} || die $USAGE;


my $vmware = CNMScripts::vSphereSDK->new('server'=>$ip, 'user'=>$user, 'pwd'=>$pwd, 'port'=>$port);

#--------------------------------------------------------------------------------------
# Estas dos lineas son importantes de cara a mejorar la eficiencia de las metricas
# 10 => Sin conectividad WMI con el equipo.
#--------------------------------------------------------------------------------------
my ($ok,$lapse) = $vmware->check_tcp_port($ip,'443',5);
#if (! $ok) { $vmware->host_status($ip,10);}

$vmware->connect();
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my $ds = $vmware->get_datastores_info();

$vmware->disconnect();

print Dumper($ds);
