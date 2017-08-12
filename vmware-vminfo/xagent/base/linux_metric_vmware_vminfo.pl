#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_metric_vmware_vminfo.pl
#
# DESCRIPTION:
# Obtiene valores de estado de las VMs definidas en un host ESX/ESXi a partir del API de vSphere
#
# CALLING SAMPLE:
# linux_metric_vmware_vminfo.pl -n 1.1.1.1 -u user -p xxx 
# linux_metric_vmware_vminfo.pl -h  : Ayuda
#
# INPUT (PARAMS):
# a. -n  :  IP remota
# b. -u  :  Usuario WMI
# c. -p  :  Clave
# d. -P  :  Puerto (opcional, por defecto el 443)
#
# OUTPUT (STDOUT):
# <100.CNM-DEVEL> powerState = poweredOff
# <101.CNM-DEVEL> connectionState = connected
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
use lib '/opt/cnm-sp/vmware-vsphere-cli-distrib-5.5.0/lib/libwww-perl-5.805/lib/';
use lib '/opt/crawler/bin/';
use strict;
use Getopt::Std;
use Data::Dumper;
use Stdout;
use CNMScripts::vSphereSDK;

#--------------------------------------------------------------------------------------
my $counters;

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
linux_metric_vmware_vminfo.pl $VERSION

$fpth[$#fpth] -n IP -u user -p pwd [-P port]
$fpth[$#fpth] -h  : Ayuda

-n    IP remota (server)
-u    user
-p    pwd
-P    port	(Optional. Defaults 443)
-h    Ayuda

$fpth[$#fpth] -n 1.1.1.1 -u user -p xxx
$fpth[$#fpth] -n 1.1.1.1 -u user -p xxx -P 4443
USAGE

#--------------------------------------------------------------------------------------
my %opts=();
getopts("hn:u:p:d:P:s:",\%opts);

if ($opts{h}) { die $USAGE;}
my $ip = $opts{n} || die $USAGE;
my $port = $opts{P} || '443';
my $user = $opts{u} || die $USAGE;
my $pwd = $opts{p} || die $USAGE;

my $vmware = CNMScripts::vSphereSDK->new('server'=>$ip, 'user'=>$user, 'pwd'=>$pwd, 'port'=>$port);

#--------------------------------------------------------------------------------------
# Estas dos lineas son importantes de cara a mejorar la eficiencia de las metricas
# 10 => Sin conectividad WMI con el equipo.
#--------------------------------------------------------------------------------------
my $ok=$vmware->check_tcp_port($ip,'443',5);

$vmware->connect();

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my %summary = ();
my ($mtype,$m,$tag,$value);
my $vm_info = $vmware->get_vm_info();

$vmware->disconnect();

#print Dumper($vm_info);

#          'CNM-DEVEL' => {
#                         'maxCpuUsage' => '2995',
#                         'cleanPowerOff' => '1',
#                         'powerState' => 'poweredOff',
#                         'numMksConnections' => '0',
#                         'maxMemoryUsage' => '2048',
#                         'toolsInstallerMounted' => '0',
#                         'connectionState' => 'connected',
#                         'faultToleranceState' => 'notConfigured'
#                       },

#--------------------------------------------------------------------------------------
$mtype='disk';
#--------------------------------------------------------------------------------------
%summary = ( 'poweredOn'=>0, 'suspended'=>0, 'poweredOff'=>0 );

($tag,$m,$value) = ('100','powerState','U');
my %powerState_map = ( 'poweredOn'=>1, 'suspended'=>2, 'poweredOff'=>3 );
foreach my $iid (sort keys %{$vm_info}) {
   $value='U';
   if (exists $vm_info->{$iid}->{$m}) { $value=$vm_info->{$iid}->{$m}; }
	if (exists $summary{$value}) { $summary{$value}+=1; }
	$vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> $m, 'value'=>$value}, \%powerState_map);
}

($tag,$m,$value) = ('101','powerOnSummary','U');
if (exists $summary{'poweredOn'}) { $value = $summary{'poweredOn'}; }
$vmware->print_counter_value({'tag'=>$tag, 'descr'=> $m, 'value'=>$value}, {});

($tag,$m,$value) = ('102','suspendedSummary','U');
if (exists $summary{'suspended'}) { $value = $summary{'suspended'}; }
$vmware->print_counter_value({'tag'=>$tag, 'descr'=> $m, 'value'=>$value}, {});

($tag,$m,$value) = ('103','powerOffSummary','U');
if (exists $summary{'poweredOff'}) { $value = $summary{'poweredOff'}; }
$vmware->print_counter_value({'tag'=>$tag, 'descr'=> $m, 'value'=>$value}, {});


#connected Connected to the server. For ESX Server, this is always the setting.  
#disconnected The user has explicitly taken the host down. VirtualCenter does not expect to receive heartbeats from the host. The next time a heartbeat is received, the host is moved to the connected state again and an event is logged.  
#notResponding VirtualCenter is not receiving heartbeats from the server. The state automatically changes to connected once heartbeats are received again. This state is typically used to trigger an alarm on the host.  

%summary = ( 'connected'=>0, 'disconnected'=>0, 'notResponding'=>0 );

($tag,$m,$value) = ('104','connectionState','U');
my %connectionStateState_map = ( 'connected'=>1, 'disconnected'=>2, 'notResponding'=>3 );
foreach my $iid (sort keys %{$vm_info}) {
   $value='U';
   if (exists $vm_info->{$iid}->{$m}) { $value=$vm_info->{$iid}->{$m}; }
	if (exists $summary{$value}) { $summary{$value}+=1; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> $m, 'value'=>$value}, \%connectionStateState_map);
}

($tag,$m,$value) = ('105','connectedSummary','U');
if (exists $summary{'connected'}) { $value = $summary{'connected'}; }
$vmware->print_counter_value({'tag'=>$tag, 'descr'=> $m, 'value'=>$value}, {});

($tag,$m,$value) = ('106','disconnectedSummary','U');
if (exists $summary{'disconnected'}) { $value = $summary{'disconnected'}; }
$vmware->print_counter_value({'tag'=>$tag, 'descr'=> $m, 'value'=>$value}, {});

($tag,$m,$value) = ('107','notRespondingSummary','U');
if (exists $summary{'notResponding'}) { $value = $summary{'notResponding'}; }
$vmware->print_counter_value({'tag'=>$tag, 'descr'=> $m, 'value'=>$value}, {});


($tag,$m,$value) = ('108','maxCpuUsage','U');
foreach my $iid (sort keys %{$vm_info}) {
   $value='U';
   if (exists $vm_info->{$iid}->{$m}) { $value=$vm_info->{$iid}->{$m}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> $m, 'value'=>$value}, {});
}

($tag,$m,$value) = ('109','maxMemoryUsage','U');
foreach my $iid (sort keys %{$vm_info}) {
   $value='U';
   if (exists $vm_info->{$iid}->{$m}) { $value=$vm_info->{$iid}->{$m}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> $m, 'value'=>$value}, {});
}

($tag,$m,$value) = ('110','numMksConnections','U');
foreach my $iid (sort keys %{$vm_info}) {
   $value='U';
   if (exists $vm_info->{$iid}->{$m}) { $value=$vm_info->{$iid}->{$m}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> $m, 'value'=>$value}, {});
}

