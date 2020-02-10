#!/usr/bin/perl -w
#-------------------------------------------------------------------------------------------
use lib "/opt/crawler/bin";
use strict;
use Getopt::Long;
use CNMScripts::CNMAPI;
use Data::Dumper;

#-------------------------------------------------------------------------------------------
my %INVENTORY=(

	'devices' => { 'class'=>'', 'endpoint'=>'devices.json',
						'col_desc'=>
[
   {'label'=>'NOMBRE', 'width'=>'20' , 'name_col'=>'name',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'DOMINIO', 'width'=>'15' , 'name_col'=>'domain',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'IP', 'width'=>'12' , 'name_col'=>'ip',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'ESTADO', 'width'=>'7' , 'name_col'=>'status',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   {'label'=>'TIPO', 'width'=>'15' , 'name_col'=>'type',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   {'label'=>'SYSOID', 'width'=>'25' , 'name_col'=>'snmpsysclass',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'SYSLOC', 'width'=>'30' , 'name_col'=>'snmpsyslocation',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'SYSDESC', 'width'=>'40' , 'name_col'=>'snmpsysdesc',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'ID', 'width'=>'4' , 'name_col'=>'id',  'sort'=>'int', 'align'=>'left', 'filter'=>'#text_filter', ,'hidden'=>'true' },
],

		},

   'metrics' => { 'class'=>'', 'endpoint'=>'metrics/info.json',
                  'col_desc'=>

[
   {'label'=>'TIPO', 'width'=>'6' , 'name_col'=>'metrictype',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   {'label'=>'METRICA', 'width'=>'50' , 'name_col'=>'metricname',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'ITEMS', 'width'=>'35' , 'name_col'=>'metricitems',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'MONITOR', 'width'=>'30' , 'name_col'=>'monitorname',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'CONDICION ROJA', 'width'=>'15' , 'name_col'=>'monitorsevred',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'CONDICION NARANJA', 'width'=>'15' , 'name_col'=>'monitorsevorange',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'CONDICION AMARILLA', 'width'=>'15' , 'name_col'=>'monitorsevyellow',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'IP', 'width'=>'12' , 'name_col'=>'deviceip',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'NOMBRE', 'width'=>'12' , 'name_col'=>'devicename',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'DOMINIO', 'width'=>'12' , 'name_col'=>'devicedomain',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'ESTADO', 'width'=>'5' , 'name_col'=>'devicestatus',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   {'label'=>'ID METRICA', 'width'=>'7' , 'name_col'=>'metricid',  'sort'=>'int', 'align'=>'left', 'filter'=>'#text_filter' },
],
      },

   'views' => { 'class'=>'', 'endpoint'=>'views.json',
                  'col_desc'=>
[
   {'label'=>'NUM. METRICAS', 'width'=>'12' , 'name_col'=>'nmetrics',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'NUM. REMOTE', 'width'=>'12' , 'name_col'=>'nremote',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'SEV', 'width'=>'5' , 'name_col'=>'sev',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'NOMBRE', 'width'=>'40' , 'name_col'=>'name',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'TIPO', 'width'=>'10' , 'name_col'=>'type',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   {'label'=>'ID', 'width'=>'6' , 'name_col'=>'metricid',  'sort'=>'int', 'align'=>'left', 'filter'=>'#text_filter' },
],

      },


	'metrics_in_views' => { 'class'=>'views', 'endpoint'=>'metrics.json',
                  'col_desc'=>
[
   {'label'=>'VISTA', 'width'=>'12' , 'name_col'=>'viewname',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'TIPO DE VISTA', 'width'=>'16' , 'name_col'=>'viewtype',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   {'label'=>'ID VISTA', 'width'=>'7' , 'name_col'=>'viewid',  'sort'=>'int', 'align'=>'left', 'filter'=>'#text_filter' },
 
   {'label'=>'ID METRICA', 'width'=>'7' , 'name_col'=>'metricid',  'sort'=>'int', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'TIPO MET', 'width'=>'7' , 'name_col'=>'metrictype',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   {'label'=>'METRICA', 'width'=>'50' , 'name_col'=>'metricname',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'ITEMS', 'width'=>'35' , 'name_col'=>'metricitems',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'MONITOR', 'width'=>'30' , 'name_col'=>'monitorname',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'CONDICION ROJA', 'width'=>'15' , 'name_col'=>'monitorsevred',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'CONDICION NARANJA', 'width'=>'15' , 'name_col'=>'monitorsevorange',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'CONDICION AMARILLA', 'width'=>'15' , 'name_col'=>'monitorsevyellow',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'IP', 'width'=>'12' , 'name_col'=>'deviceip',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'NOMBRE', 'width'=>'12' , 'name_col'=>'devicename',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'DOMINIO', 'width'=>'12' , 'name_col'=>'devicedomain',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   {'label'=>'ESTADO', 'width'=>'5' , 'name_col'=>'devicestatus',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   {'label'=>'ID DISP', 'width'=>'7' , 'name_col'=>'deviceid',  'sort'=>'int', 'align'=>'left', 'filter'=>'#text_filter' },

#{ metricid : 5 ,
# metricname : USO DE DISCO \/boot (cnm-develcnm-develcnm-develcnm-develcnm-develcnm-develcnm-develcnm-develcnm-develcnm-develcnm-develcnm-develcnm-devel.kk1kk1kk1kk1kk1kk1) , 
#metrictype : snmp , metricitems : Disco Total (32)|Disco Usado (32) , 
#metricstatus : 0 , 
#metricmname : disk_mibhost-32 , 
#metricsubtype : disk_mibhost , 
#devicename : cnm-devel , 
#devicedomain : kk1 , 
#devicestatus : 2 , 
#devicetype : Servidor Linux , 
#deviceid : 1 , deviceip : 10.2.254.222 , monitorid : 45 , monitorname : DISCO USADO > 1 GB , 
#monitorsevred :  , monitorsevorange : V2>2000000000 , monitorsevyellow : v2>1000000000 , 
#viewname : test-vista-dinamica , 
#viewid : 30 , 
#viewtype : Infrastructura },


],

      },

);

#-------------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $USAGE = <<USAGE;
API Scripts - GET CNM Inventory
(c) s30labs

$fpth[$#fpth] [-d] [-cid default] [-host 1.1.1.1] -what [devices|views|metrics|metrics_in_views] 
$fpth[$#fpth] -h  : Ayuda

host: Direccion IP del CNM al que se interroga, por defecto es localhost.
what: Tipo de inventario: devices, views, metrics, metrics_in_views

USAGE

#-------------------------------------------------------------------------------------------
my ($what,$extra,$log_mode)=('devices','',3);
my %OPTS=();
GetOptions (\%OPTS, 'h','help','d','debug','host=s','cid=s','what=s','w=s','extra=s','e=s','csv')
	or die "$0:[ERROR] en el paso de parametros. Si necesita ayuda ejecute $0 -help\n";

if ( ($OPTS{'help'}) || ($OPTS{'h'}) ) { die $USAGE; }

if ( !($OPTS{'what'}) && !($OPTS{'w'}) ) { die $USAGE; }
if ($OPTS{'what'}) { $what=$OPTS{'what'}; }
else { $what=$OPTS{'w'}; }

if ($OPTS{'extra'}) { $extra=$OPTS{'extra'}; }
elsif ($OPTS{'e'}) { $what=$OPTS{'e'}; }

if (! exists $INVENTORY{$what}) {
	print "**ERROR** al especificar el valor de what/w\n";
	die $USAGE;
}

my $log_level='info';
if ( ($OPTS{'debug'}) || ($OPTS{'d'}) ) { $log_level='debug'; }
my $host_ip = (defined $OPTS{host}) ? $OPTS{host} : 'localhost';
my $cid = (defined $OPTS{cid}) ? $OPTS{cid} : 'default';

#-------------------------------------------------------------------------------------------
my $api=CNMScripts::CNMAPI->new( 'host'=>$host_ip, 'timeout'=>10, 'log_level'=>$log_level );
my ($user,$pwd)=('admin','cnm123');
my $sid = $api->ws_get_token($user,$pwd);
#print "sid=$sid\n";

my $class=$INVENTORY{$what}->{'class'};
my $endpoint=$INVENTORY{$what}->{'endpoint'};
if ($extra) { $endpoint .= '?'.$extra; }

my $response = $api->ws_get($class,$endpoint);
$api->table_col_descriptor ( $INVENTORY{$what}->{'col_desc'});

if ($OPTS{'csv'}) {
   $api->print_app_table($response, {'mode'=>'csv'});
}
else {
   $api->print_app_table($response);
}

#$api->print_app_table($response);

