#!/usr/bin/perl
# -----------------------------------------------------------------------------------
# linux_metric_ipmi_sensors.pl
# -----------------------------------------------------------------------------------
# <001> DNS1 Latency = 0.011817
# <002> DNS2 Latency = 0.010426
# <101> DNS1 TTL = 6357
# <102> DNS2 TTL = 5739
# <001. > Temperature
#
#root@cnm-inet2:/opt/cnm-sp/_check# ipmimonitoring -L
#100 status
#200 power
#001 temperature
#002 voltage
#003 current
#004 fan
#005 physical_security
#006 platform_security_violation_attempt
#007 processor
#008 power_supply
#009 power_unit
#010 memory
#011 drive_slot
#012 system_firmware_progress
#013 event_logging_disabled
#014 system_event
#015 critical_interrupt
#016 module_board
#017 slot_connector
#018 watchdog2
#019 entity_presence
#020 management_subsystem_health
#021 battery
#022 fru_state
#023 cable_interconnect
#024 boot_error
#025 button_switch
#026 system_acpi_power_state


# -----------------------------------------------------------------------------------
use lib '/opt/crawler/bin/';
use strict;
use warnings;
use Getopt::Std;
use Time::HiRes qw(gettimeofday tv_interval);
use Monitor;
use CNMScripts;
use Data::Dumper;

# -----------------------------------------------------------------------------------
my $script = CNMScripts->new();

my %opts=();
#-h    Ayuda
#-b    Genera alerta azul
#-n    Host (Nombre a resolver)
#-t    Timeout (opcional)
#-r    Versión IPMI. Las opciones posibles son 1.5 y 2.0. Por defecto se hace con 1.5
#-u    Nombre de usuario
#-p    Contraseña
#-s    Tipo de sensor. En caso de no indicarlo devuelve todos.

getopts('hbn:t:r:u:p:s:',\%opts);

my @output;

if ($opts{h}) { usage();}
if ((! exists $opts{n}) || (!$opts{n})) { usage();}

my ($timeout,$host,$ipmi_version,$username,$password,$local,$cmd,$sensor_type,$ipmi_status,$ipmi_power)=(5000,$opts{n},'1.5','','',0,'','all',0,0);

if ((exists $opts{s}) && ($opts{s})){ $sensor_type = $opts{s} };
if ((exists $opts{t}) && ($opts{t}=~/\d+/)) { $timeout=$opts{t}*1000;}
if ((exists $opts{r}) && ($opts{r} eq '2.0')) { $ipmi_version=$opts{r};}
		
my $local_ip = 'localhost';
my $r=`/sbin/ifconfig eth0`;
if ($r=~/inet\s+addr\:(\d+\.\d+\.\d+\.\d+)\s+/) { $local_ip = $1; }
if ( ($host eq 'localhost') || ($host eq '127.0.0.1') || ($host eq $local_ip) ) { $local=1; }

# IPMI remoto
if ($local==0){
	if((! exists $opts{u}) || (!$opts{u})) { usage();}
	$username = $opts{u};

	if((! exists $opts{p}) || (!$opts{p})) { usage();}
	$password = $opts{p};
}

$script->log('info',"host=$host revision=$ipmi_version username=$username password=$password timeout=$timeout");

# -----------------------------------------------------------------------------------
# ############################ #
# Comprobar si responde a IPMI #
# ############################ #
# IPMI remoto
if($local==0){
	$cmd="/usr/sbin/ipmimonitoring -h $host -u $username -p $password --sdr-cache-recreate --session-timeout=$timeout 2>/dev/null";
}
# IPMI local
else{
	$cmd="/usr/sbin/ipmimonitoring --sdr-cache-recreate --session-timeout=$timeout 2>/dev/null";
}
@output = `$cmd`;

if($?==0) {$ipmi_status = 1;}

$script->test_init('100', "status");
$script->test_done('100', $ipmi_status);

# -----------------------------------------------------------------------------------
my %base_sensor_group = ( 
	'temperature'                         => '001',
	'voltage'                             => '002',
	'current'                             => '003',
	'fan'                                 => '004',
	'physical_security'                   => '005',
	'platform_security_violation_attempt' => '006',
	'processor'                           => '007',
	'power_supply'                        => '008',
	'power_unit'                          => '009',
	'memory'                              => '010',
	'drive_slot'                          => '011',
	'system_firmware_progress'            => '012',
	'event_logging_disabled'              => '013',
	'system_event'                        => '014',
	'critical_interrupt'                  => '015',
	'module_board'                        => '016',
	'slot_connector'                      => '017',
	'watchdog2'                           => '018',
	'entity_presence'                     => '019',
	'management_subsystem_health'         => '020',
	'battery'                             => '021',
	'fru_state'                           => '022',
	'cable_interconnect'                  => '023',
	'boot_error'                          => '024',
	'button_switch'                       => '025',
	'system_acpi_power_state'             => '026',
);

# -----------------------------------------------------------------------------------
my $line_n = 0;
foreach my $line (@output){
	if($line_n!=0){
		chomp($line);
		#print "$line\n";
		my @a_sensor = split / \| /, $line;
		my $sensor_id      = $a_sensor[0];
		my $sensor_name    = lc($a_sensor[1]);
		my $sensor_group   = lc($a_sensor[2]);
		$sensor_group =~ s/ /_/g;
		my $sensor_status  = lc($a_sensor[3]);
		my $sensor_units   = lc($a_sensor[4]);
		my $sensor_reading = lc($a_sensor[5]);
		$sensor_reading =~ s/[',"]//g;
		
		
		#print "ID == $sensor_id || NAME == $sensor_name || GROUP == $sensor_group || STATUS == $sensor_status || UNITS == $sensor_units || READING == $sensor_reading\n";
		if(($sensor_type eq 'all') || $sensor_group eq $sensor_type){
			if($base_sensor_group{$sensor_group} eq '005'){
				$script->test_init($base_sensor_group{$sensor_group}, "$sensor_name $sensor_group");
				$script->test_done($base_sensor_group{$sensor_group}, $sensor_reading);
			}
			else{
				$script->test_init($base_sensor_group{$sensor_group}.".".$sensor_name, "$sensor_name $sensor_group");
				$script->test_done($base_sensor_group{$sensor_group}.".".$sensor_name, $sensor_reading);
			}
		}
	}
	$line_n++;	
}

# -----------------------------------------------------------------------------------
# ########################################## #
# Comprobar el estado de power de la máquina #
# ########################################## #
if($ipmi_status==1){
   if($local==0){
      my $cmd_power="/usr/sbin/ipmipower -h $host -u $username -p $password --session-timeout=$timeout -s|grep 'on'|wc -l 2>/dev/null";
	   my $output =`$cmd_power`;
		chomp($output);
	   if($?==0){ $ipmi_power = $output;}
	}
	else{
		$ipmi_power = 1;
	}
	$script->test_init('200', "power");
	$script->test_done('200', $ipmi_power);
}


my $data=$script->test_results();
$script->print_metric_data($data);

#----------------------------------------------------------------------------
# usage
#----------------------------------------------------------------------------
sub usage {

   my @fpth = split ('/',$0,10);
   my $fname=$0;
   if ($fname=~/.+\/(.+)$/) { $fname=$1; }
   my $VERSION="1.0";

my $USAGE = <<USAGE;
$fname v$VERSION

$fname -n IP/Host -u Usuario -p Contraseña [-t timeout] [-r revision] [-s tipo de sensor]
$fname -h

-n    Host (Nombre a resolver)
-t    Timeout (opcional)
-b    Genera alerta azul
-r    Versión IPMI. Las opciones posibles son 1.5 y 2.0. Por defecto se hace con 1.5
-u    Nombre de usuario
-p    Contraseña
-h    Ayuda
-s    Tipo de sensor. En caso de no indicarlo devuelve todos. Los sensores disponibles son:
      - temperature
      - voltage
      - current
      - fan
      - physical_security
      - platform_security_violation_attempt
      - processor
      - power_supply
      - power_unit
      - memory
      - drive_slot
      - system_firmware_progress
      - event_logging_disabled
      - system_event
      - critical_interrupt
      - module_board
      - slot_connector
      - watchdog2
      - entity_presence
      - management_subsystem_health
      - battery
      - fru_state
      - cable_interconnect
      - boot_error
      - button_switch
      - system_acpi_power_state
USAGE

   die $USAGE;

}
