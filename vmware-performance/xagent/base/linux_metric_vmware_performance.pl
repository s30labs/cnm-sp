#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_metric_vmware_performance.pl
#
# DESCRIPTION:
# Obtiene valores de los contadores de performance definidos en el API de vSphere
#
# CALLING SAMPLE:
# linux_metric_vmware_performance.pl -n 1.1.1.1 -u user -p xxx -H myhost
# linux_metric_vmware_performance.pl -h  : Ayuda
#
# INPUT (PARAMS):
# a. -n  :  IP remota
# b. -u  :  Usuario WMI
# c. -p  :  Clave
# d. -H  :  Nombre de host (opcional)
# e. -P  :  Puerto (opcional, por defecto el 443)
#
# OUTPUT (STDOUT):
# <100> cpu - Usage in MHz: 29.000
# <101> cpu - Usage: 98.000
# <200> mem - Consumed: 2365104.000
# <201> mem - Usage: 98.000
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
linux_metric_vmware_performance.pl $VERSION

$fpth[$#fpth] -n IP -u user -p pwd [-H host_ame] [-P port]
$fpth[$#fpth] -h  : Ayuda

-n    IP remota (server)
-u    user
-p    pwd
-P    port	(Optional. Defaults 443)
-H    Host Name (Optional)
-s    Number of samples (Optional. Defaults 15)
-h    Ayuda

$fpth[$#fpth] -n 1.1.1.1 -u user -p xxx
$fpth[$#fpth] -n 1.1.1.1 -u user -p xxx -H myhost
$fpth[$#fpth] -n 1.1.1.1 -u user -p xxx -H myhost -P 4443
USAGE

#--------------------------------------------------------------------------------------
my %opts=();
getopts("hn:u:p:d:H:P:s:",\%opts);

if ($opts{h}) { die $USAGE;}
my $ip = $opts{n} || die $USAGE;
my $port = $opts{P} || '443';
my $user = $opts{u} || die $USAGE;
my $pwd = $opts{p} || die $USAGE;
my $host = $opts{H} || '';
my $samples = $opts{s} || 15;


my $vmware = CNMScripts::vSphereSDK->new('server'=>$ip, 'user'=>$user, 'pwd'=>$pwd, 'port'=>$port, 'samples'=>$samples);

#--------------------------------------------------------------------------------------
# Estas dos lineas son importantes de cara a mejorar la eficiencia de las metricas
# 10 => Sin conectividad WMI con el equipo.
#--------------------------------------------------------------------------------------
my $ok=$vmware->check_tcp_port($ip,'443',5);

$vmware->connect();

if ($host eq '') {
   my $hosts = $vmware->get_host_info(1);
   my @h = keys %$hosts;
   $host = $h[0];
}
$vmware->host($host);

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my ($mtype,$m,$tag,$value);
$counters = $vmware->get_performance_counters();

$vmware->disconnect();

#print Dumper($counters);
#cpu: Usage in MHz - ALL >> 60 (20,2013-11-06T11:59:40Z)
#cpu: Usage - ALL >> 203 (20,2013-11-06T11:59:40Z) (/100 %) ==> 2,03%

#--------------------------------------------------------------------------------------
$mtype='cpu';
#--------------------------------------------------------------------------------------
($tag,$m,$value) = ('100','Usage in MHz','U');
if (exists $counters->{$mtype}->{$m}->{'ALL'}) { $value=$counters->{$mtype}->{$m}->{'ALL'}; }
$vmware->print_counter_value({'tag'=>$tag, 'descr'=> "$mtype - $m", 'value'=>$value}, {});


($tag,$m,$value) = ('101','Usage','U');
if (exists $counters->{$mtype}->{$m}->{'ALL'}) { 
	$value=$counters->{$mtype}->{$m}->{'ALL'}; 
	$value /= 100;
}
$vmware->print_counter_value({'tag'=>$tag, 'descr'=> "$mtype - $m", 'value'=>$value}, {});

#--------------------------------------------------------------------------------------
$mtype='mem';
#--------------------------------------------------------------------------------------
($tag,$m,$value) = ('200','Usage','U');
if (exists $counters->{$mtype}->{$m}->{'ALL'}) { $value=$counters->{$mtype}->{$m}->{'ALL'}; }
$vmware->print_counter_value({'tag'=>$tag, 'descr'=> "$mtype - $m", 'value'=>$value}, {});

($tag,$m,$value) = ('201','Consumed','U');
if (exists $counters->{$mtype}->{$m}->{'ALL'}) { $value=$counters->{$mtype}->{$m}->{'ALL'}; }
$vmware->print_counter_value({'tag'=>$tag, 'descr'=> "$mtype - $m", 'value'=>$value}, {});

($tag,$m,$value) = ('202','Overhead','U');
if (exists $counters->{$mtype}->{$m}->{'ALL'}) { $value=$counters->{$mtype}->{$m}->{'ALL'}; }
$vmware->print_counter_value({'tag'=>$tag, 'descr'=> "$mtype - $m", 'value'=>$value}, {});

($tag,$m,$value) = ('203','Shared','U');
if (exists $counters->{$mtype}->{$m}->{'ALL'}) { $value=$counters->{$mtype}->{$m}->{'ALL'}; }
$vmware->print_counter_value({'tag'=>$tag, 'descr'=> "$mtype - $m", 'value'=>$value}, {});

($tag,$m,$value) = ('204','Swap used','U');
if (exists $counters->{$mtype}->{$m}->{'ALL'}) { $value=$counters->{$mtype}->{$m}->{'ALL'}; }
$vmware->print_counter_value({'tag'=>$tag, 'descr'=> "$mtype - $m", 'value'=>$value}, {});

($tag,$m,$value) = ('205','Balloon','U');
if (exists $counters->{$mtype}->{$m}->{'ALL'}) { $value=$counters->{$mtype}->{$m}->{'ALL'}; }
$vmware->print_counter_value({'tag'=>$tag, 'descr'=> "$mtype - $m", 'value'=>$value}, {});

($tag,$m,$value) = ('206','State','U');
if (exists $counters->{$mtype}->{$m}->{'ALL'}) { $value=$counters->{$mtype}->{$m}->{'ALL'}; }
$vmware->print_counter_value({'tag'=>$tag, 'descr'=> "$mtype - $m", 'value'=>$value}, {});


#--------------------------------------------------------------------------------------
$mtype='disk';
#--------------------------------------------------------------------------------------
($tag,$m,$value) = ('300','Commands aborted','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
	$vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('301','Bus resets','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('302','Queue read latency','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('303','Queue write latency','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('304','Queue command latency','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('305','Kernel read latency','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('306','Kernel write latency','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('307','Kernel command latency','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('308','Read latency','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('309','Write latency','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('310','Command latency','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('311','Physical device read latency','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('312','Physical device write latency','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('313','Physical device command latency','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

#--------------------------------------------------------------------------------------
$mtype='net';
#--------------------------------------------------------------------------------------
($tag,$m,$value) = ('400','Packets transmitted','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
	if ($iid eq 'ALL') { next; }
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('401','Packets received','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
	if ($iid eq 'ALL') { next; }
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('402','Broadcast transmits','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   if ($iid eq 'ALL') { next; }
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('403','Broadcast receives','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   if ($iid eq 'ALL') { next; }
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('404','Multicast transmits','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   if ($iid eq 'ALL') { next; }
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('405','Multicast receives','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   if ($iid eq 'ALL') { next; }
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('406','Packet transmit errors','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   if ($iid eq 'ALL') { next; }
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('407','Packet receive errors','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   if ($iid eq 'ALL') { next; }
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('408','Transmit packets dropped','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   if ($iid eq 'ALL') { next; }
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('409','Receive packets dropped','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   if ($iid eq 'ALL') { next; }
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('410','Latency','U');
if (exists $counters->{$mtype}->{$m}->{'ALL'}) { $value=$counters->{$mtype}->{$m}->{'ALL'}; }
$vmware->print_counter_value({'tag'=>$tag, 'descr'=> "$mtype - $m", 'value'=>$value}, {});

#--------------------------------------------------------------------------------------
$mtype='ds';
#--------------------------------------------------------------------------------------
($tag,$m,$value) = ('500','Available space','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
	$value='U';
	if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('501','Maximum Capacity','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
	$value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('502','Usage (%)','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
	$value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('503','Available space (MB)','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

($tag,$m,$value) = ('504','Maximum Capacity (MB)','U');
foreach my $iid (sort keys %{$counters->{$mtype}->{$m}}) {
   $value='U';
   if (exists $counters->{$mtype}->{$m}->{$iid}) { $value=$counters->{$mtype}->{$m}->{$iid}; }
   $vmware->print_counter_value({'tag'=>$tag, 'iid'=>$iid, 'descr'=> "$mtype - $m", 'value'=>$value}, {});
}

#print Dumper($counters);

