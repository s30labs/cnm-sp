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
API Scripts - Modifica campos de dispositivos
(c) s30labs

$fpth[$#fpth] [-d] [-cid default] -ip=1.1.1.1 -status 0 -domain nuevo.com
$fpth[$#fpth] [-d] [-cid default] -id=1 -status 0 -domain nuevo.com
$fpth[$#fpth] -h  : Ayuda

id:          Id del dispositivo cuyo campo/campos se van a actualizar.
ip:          IP del dispositivo cuyo campo/campos se van a actualizar.
name:        Nombre del dispositivo
domain:      Dominio del dispositivo
type:        Tipo del dispositivo
geo:         Coordenadas de Geolocalizacion del dispositivo
critic:      Criticidad del dispositivo
correlated:  ID del dispositivo del que depende
status:      Estado del dispositivo (0:activo | 1:inactivo | 2:mantenimiento)
profile:     Perfil al que pertenece el dispositivo
user:        Permite especificar valores para campos de usuario. P. ej: Precio=1000,Proveedor=s30labs

USAGE

#-------------------------------------------------------------------------------------------
#// Campos que se pueden modificar:
#// - name           => nombre
#// - domain         => dominio
#// - ip             => direccion ip
#// - type           => tipo de dispositivo
#// - snmpversion    => 0:sin SNMP | 1:version 1 | 2:version 2 | 3:version 3 (0 si no se indica)
#// - snmpcommunity  => comunidad snmp (versiones 1 y 2)
#// - snmpcredential => credencial snmp (version 3)
#// - entity         => 0:dispositivo físico | 1:servicio web (0 si no se indica)
#// - geo            => geolocalizacion en formato Google Maps
#// - critic         => 25:criticidad baja | 50:criticidad media | 75:criticidad alta | 100:criticidad maxima (50 si no se indica)
#// - correlated     => ID del dispositivo del que depende
#// - status         => 0:activo | 1:inactivo | 2:mantenimiento (0 si no se indica)
#// - profile        => perfil al que pertenece el dispositivo
#// - Cualquier campo de usuario
#
#sub ws_put  {
#my ($self,$class,$endpoint,$params)=@_;

my $prog_cmd="$0 @ARGV";
my ($log_mode,$host_ip,$element)=(3,'localhost',undef);
my %OPTS=();
GetOptions (\%OPTS, 	'h','help','d','debug','cid=s','name=s','domain=s','ip=s','id=s','type=s',
							'geo=s','critic=s','correlated=s','status=s','profile=s','user=s')
	or die "$0:[ERROR] en el paso de parametros. Si necesita ayuda ejecute $0 -help\n";

if ( ($OPTS{'help'}) || ($OPTS{'h'}) ) { die $USAGE; }

my $log_level='info';
if ( ($OPTS{'debug'}) || ($OPTS{'d'}) ) { $log_level='debug'; }
my $cid = (defined $OPTS{cid}) ? $OPTS{cid} : 'default';

my %params=();
if (defined $OPTS{'name'}) { $params{'name'}  = $OPTS{'name'}; }
if (defined $OPTS{'domain'}) { $params{'domain'}  = $OPTS{'domain'}; }
#if (defined $OPTS{'ip'}) { $params{'ip'}  = $OPTS{'ip'}; }
#if (defined $OPTS{'id'}) { $params{'id'}  = $OPTS{'id'}; }
if (defined $OPTS{'type'}) { $params{'type'}  = $OPTS{'type'}; }
if (defined $OPTS{'geo'}) { $params{'geo'}  = $OPTS{'geo'}; }
if (defined $OPTS{'critic'}) { $params{'critic'}  = $OPTS{'critic'}; }
if (defined $OPTS{'correlated'}) { $params{'correlated'}  = $OPTS{'correlated'}; }
if (defined $OPTS{'status'}) { $params{'status'}  = $OPTS{'status'}; }
if (defined $OPTS{'profile'}) { $params{'profile'}  = $OPTS{'profile'}; }
if (defined $OPTS{'user'}) { 
	#Precio=1000,Proveedor=s30labs
	my @f = split(',',$OPTS{'user'});
	foreach my $x (@f) {
		my ($k,$v)=split('=',$x);
		$params{$k}  = $v;
	}
}

if (scalar(keys %params) == 0) {
	print "**ERROR** Es necesario especificar algun campo del dispositivo\n";
	die $USAGE;
}
if (exists $OPTS{'ip'}) { $element=$OPTS{'ip'}; } 
elsif (exists $OPTS{'id'}) { $element=$OPTS{'id'}; }

if (! defined $element ) {
   print "**ERROR** Es necesario especificar el campo ip o id del dispositivo\n";
   die $USAGE;
}

#-------------------------------------------------------------------------------------------
my $api=CNMScripts::CNMAPI->new( 'host'=>$host_ip, 'timeout'=>10, 'log_level'=>$log_level );
my ($user,$pwd)=('admin','cnm123');
my $sid = $api->ws_get_token($user,$pwd);
#print "sid=$sid\n";

my $class='devices';
my $endpoint=$element.'.json';

#print Dumper(\%params);

my $response = $api->ws_put($class,$endpoint,\%params);

#print Dumper($response);


$response->{'action'} = $prog_cmd;

$api->table_col_descriptor ( 
[
   {'label'=>'ACCION', 'width'=>'30' , 'name_col'=>'action',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'RC', 'width'=>'5' , 'name_col'=>'rc',  'sort'=>'int', 'align'=>'left', 'filter'=>'#select_filter' },
   {'label'=>'MENSAJE', 'width'=>'25' , 'name_col'=>'rcstr',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'DISPOSITIVO', 'width'=>'12' , 'name_col'=>'id',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
]
);
$api->print_app_table([$response]);

