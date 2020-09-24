#!/usr/bin/perl -w
#-------------------------------------------------------------------------------------------
use lib "/opt/crawler/bin";
use strict;
use Getopt::Long;
use CNMScripts::CNMAPI;
use Data::Dumper;

#-------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $USAGE = <<USAGE;
API Scripts - Obtiene el estado de un dispositivo >> Activo(0), Baja(1), Mantenimiento(2)
(c) s30labs

$fpth[$#fpth] [-v] [-id id_dev|name|ip]
$fpth[$#fpth] -h  : Ayuda

id:          Id del dispositivo. Puede ser id_dev, ip o host_name (name+domain)

USAGE

#-------------------------------------------------------------------------------------------
my ($log_mode,$host_ip,$element)=(3,'localhost',undef);
my %OPTS=();
GetOptions (\%OPTS, 	'h','help','v','verbose','id=s')
	or die "$0:[ERROR] en el paso de parametros. Si necesita ayuda ejecute $0 -help\n";

if ( ($OPTS{'help'}) || ($OPTS{'h'}) ) { die $USAGE; }

my $VERBOSE=0;
my $log_level='info';
if ( ($OPTS{'v'}) || ($OPTS{'verbose'}) ) { 
	$log_level='debug'; 
	$VERBOSE=1;
}

if (! defined $OPTS{'id'}) { die $USAGE; }

#-------------------------------------------------------------------------------------------
my $api=CNMScripts::CNMAPI->new( 'host'=>$host_ip, 'timeout'=>10, 'log_level'=>$log_level );
my ($user,$pwd)=('admin','cnm123');
my $sid = $api->ws_get_token($user,$pwd);
if ($VERBOSE) { print "sid=$sid\n"; }

my	$class='devices';
my $endpoint='';
if ( $OPTS{'id'}=~/^\d+$/) { 
   $endpoint = $OPTS{'id'}.'.json';
}
elsif ( $OPTS{'id'}=~/^\d+\.\d+\.\d+\.\d+$/) {
	$endpoint = $OPTS{'id'}.'.json';
}
else {
	$class='';
	if ($OPTS{'id'}=~/^(\w+?)\.(.*)$/) { 
   	$endpoint='devices.json?name='.$1.'&domain='.$2;
	}
	else { 
		$endpoint='devices.json?name='.$OPTS{'id'};
	}
}

if ($VERBOSE) { print "endpoint=$endpoint---\n"; }

my $response = $api->ws_get($class,$endpoint);

my ($STATUS,$RC)=(0,0);
if ($api->err_num() != 0) {
	$STATUS = 3;
	$RC=$api->err_num();
	print STDERR '**ERROR** ($RC) >>'.$api->err_str()."\n";
}
else {
	$STATUS = $response->[0]->{'status'};
}
if ($VERBOSE) { print Dumper($response); }

# 0 -> Activo
# 1 -> Baja
# 2 -> Mantenimiento
# 3 -> Desconocido

$api->test_init('001','Device Status');
$api->test_init('002','RC');
$api->test_done('001',$STATUS);
$api->test_done('002',$RC);
$api->print_metric_data();

exit 0;

