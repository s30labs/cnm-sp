#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME:  linux_metric_www_base.pl
# AUTHOR:  fmarin\@s30labs.com
# DATE: 27/01/2015
# VERSION: 1.0
#
# DESCRIPTION:
# Obtiene metricas basadas en el contenido de una pagina WEB
#
# USAGE:
# linux_metric_www_base.pl -id 1
# linux_metric_www_base.pl -ip 86.109.126.250
# linux_metric_www_base.pl -n www -d s30labs.com [-cfg credentials.json]
# linux_metric_www_base.pl -name www -domain s30labs.com [-cfg credentials.json]
# linux_metric_www_base.pl -u http://www.s30labs.com -pattern cnm [-cfg credentials.json]
# linux_metric_www_base.pl -u http://www.s30labs.com -l 
# linux_metric_www_base.pl -h
#
# -id
#      ID del dispositivo sobre el que se ejecuta el script. Los dispositivos deben tenere definido un campo URL de tipo listaa con las URLs a monitorizar.
# -n, -name  
#      Nombre del dispositivo sobre el que se ejecuta el script. Los dispositivos deben tenere definido un campo URL de tipo listaa con las URLs a monitorizar.
# -d, -domain  
#      Nombre del dispositivo sobre el que se ejecuta el script. Los dispositivos deben tenere definido un campo URL de tipo listaa con las URLs a monitorizar.
# -u, -url
#      URL sobre la que se hace la peticion
# -pattern
#      Patron de busqueda.  Contiene una cadena de texto que se busca dentro del contenido de la pagina.
# -cfg
#      Fichero de credenciales.  Fichero JSON con las credenciales necesarias para la conexión. Debe estar el areaa de ficheros de configuración de CNM.
# -v, -verbose 
#      Muestra informacion extra(debug)
# -h, -help    
#      Ayuda
# -l
#      Lista las metricas que obtiene (es necesario especificar u,url,n o id)
#
# </CNMDOCU>
#--------------------------------------------------------------------
MYHEADER
};
use lib "/opt/crawler/bin";
use Getopt::Long;
use Data::Dumper;
use CNMScripts::WWW;
use CNMScripts::CNMAPI;
use JSON;
use File::Basename;
use Digest::MD5 qw(md5_hex);


# Parametros de entrada ---------------------------------------------
my %DESC=();
my @ALL_URLS=();
my $host_name='';
my $log_level='info';
my %OPTS = ();
GetOptions (\%OPTS,  'h','help','v','verbose','n=s','name=s','d=s','domain=s','u=s','url=s','p=s','port=s','t=s','type=s','l',
							'iid=s', 'pattern=s', 'ip=s', 'cfg=s',
                     'use_realm','realm_user=s','realm_pwd=s','id=s',
                     'use_proxy','proxy_user=s','proxy_pwd=s','proxy_host=s','proxy_port=s')
            or die "$0:[ERROR] en el paso de parametros. Si necesita ayuda ejecute $0 -help\n";

my $SCRIPT=CNMScripts::WWW->new();

if ( ($OPTS{'help'}) || ($OPTS{'h'}) ) { 
   $SCRIPT->usage($main::MYHEADER);
   exit 1;
}

elsif (($OPTS{'u'}) || ($OPTS{'url'})) {

   if ($OPTS{'u'}) {  $DESC{'url'}=$OPTS{'u'}; }
   if ($OPTS{'url'}) { $DESC{'url'}=$OPTS{'url'}; }
   if ($DESC{'url'} =~ /^\d+\.\d+\.\d+\.\d+$/) { $DESC{'url'}="http://$DESC{'url'}";}
   if ($DESC{'url'} !~ /^http/) { $DESC{'url'}="http://DESC{'url'}";}
   push @ALL_URLS,$DESC{'url'};

}

elsif (	($OPTS{'id'}) || ($OPTS{'ip'}) || 
			($OPTS{'n'} && $OPTS{'d'}) || ($OPTS{'name'} && $OPTS{'d'}) || ($OPTS{'n'} && $OPTS{'domain'}) || ($OPTS{'name'} && $OPTS{'domain'}) ) {

	my $host_ip = 'localhost';
	my $api=CNMScripts::CNMAPI->new( 'host'=>$host_ip, 'timeout'=>10, 'log_level'=>$log_level );
	my ($user,$pwd)=('admin','cnm123');
	my $sid = $api->ws_get_token($user,$pwd);

	my ($class,$endpoint) = ('devices','');
  	if (exists $OPTS{'ip'}) { $endpoint = $OPTS{'ip'}.'.json'; }
   elsif (exists $OPTS{'id'}) { $endpoint = $OPTS{'id'}.'.json'; }
	else {
		my ($name,$domain)=('','');
		if (exists $OPTS{'n'}) { $name=$OPTS{'n'}; }
		elsif (exists $OPTS{'name'}) { $name=$OPTS{'name'}; }
		if (exists $OPTS{'d'}) { $domain=$OPTS{'d'}; }
		elsif (exists $OPTS{'domain'}) { $domain=$OPTS{'domain'}; }

		$class = '';
		$endpoint = 'devices.json?name='.$name.'&domain='. $domain;
	}
		
	my $response = $api->ws_get($class,$endpoint,{});

   if ($response->[0]->{'name'} eq '') {
      print STDERR "**ERROR** NO SE LOCALIZA EL DISPOSITIVO (class=$class endpoint=$endpoint)\n";
		$SCRIPT->log('info',"Termino...  NO SE LOCALIZA EL DISPOSITIVO (class=$class endpoint=$endpoint)");

   }

	if (exists $response->[0]->{'URL'}) {
		# OJO!! El caracter @ se interpreta en el eval como un array y el $ como escalar.
		$response->[0]->{'URL'} =~ s/@/\\@/g;	
		$response->[0]->{'URL'} =~ s/\$/\\\$/g;	
		my $url = eval($response->[0]->{'URL'});
		if ( ref($url) eq 'ARRAY') {
			foreach my $u (@{$url}) {push @ALL_URLS,$u; }
		}
	}
	#print Dumper($response);

}

elsif (! exists $OPTS{'l'}) {
   $SCRIPT->usage($main::MYHEADER);
   exit 1;
}

my $VERBOSE=0;
if ( ($OPTS{'verbose'}) || ($OPTS{'v'}) ) { $VERBOSE=1; }
$DESC{'verbose'} = $VERBOSE;

$DESC{'pattern'} = '';
if ($OPTS{'pattern'}) { $DESC{'pattern'} = $OPTS{'pattern'}; }

if ($OPTS{'use_realm'}) {
   $DESC{'use_realm'}=$OPTS{'use_realm'};
   $DESC{'realm_user'}=$OPTS{'realm_user'};
   $DESC{'realm_pwd'}=$OPTS{'realm_pwd'};
}
if ($OPTS{'use_proxy'}) {
   $DESC{'use_proxy'}=$OPTS{'use_proxy'};
   $DESC{'proxy_user'}=$OPTS{'proxy_user'};
   $DESC{'proxy_pwd'}=$OPTS{'proxy_pwd'};
   $DESC{'proxy_host'}=$OPTS{'proxy_host'};
   $DESC{'proxy_port'}=$OPTS{'proxy_port'};
}

$DESC{'profile'} = {};
if ($OPTS{'cfg'}) {	
	my $file_cfg = $SCRIPT->get_config_files_dir().'/'.$OPTS{'cfg'};
	if ($VERBOSE) { print "CFG: $file_cfg\n"; }
   if (-f $file_cfg) {
      my $data = $SCRIPT->slurp_file($file_cfg);
		if ($VERBOSE) { print "DATA: $data\n"; }
      eval {
         $DESC{'profile'} = decode_json($data);
      };
      if ($@) { 
	      print STDERR "**ERROR** REVISAR FICHERO $OPTS{'cfg'} ($@)\n";
   	   $SCRIPT->log('info',"Termino...  REVISAR FICHERO $OPTS{'cfg'} ($@)");
   	}
	}
	else {
      print STDERR "**ERROR** NO EXISTE FICHERO $OPTS{'cfg'}\n";
      $SCRIPT->log('info',"Termino...  NO EXISTE FICHERO $OPTS{'cfg'}");
	}
}

if ($VERBOSE) { print Dumper(\%DESC); }

foreach my $iid (@ALL_URLS) {

   $DESC{'url'}=$iid;

	#--------------------------------------------------------------------
	my ($OOO, $OO1, $OO2, $OO3, $OO4, $OO5, $OO6) = ("000.$iid", "001.$iid", "002.$iid", "003.$iid", "004.$iid", "005.$iid", "006.$iid");

	my %TAGS=( 

		$OOO=>'RC', $OO1=>'T (sgs)', $OO2=>'Size', $OO3=>"Num. ocurrencias de \"$DESC{'pattern'}\"", $OO4=>'Return Code Type',  $OO5=>'Num. Links', $OO6=>'Return Code'

	);

	if ($OPTS{'l'}) {
   	foreach my $tag (sort keys %TAGS) { print "<$tag>\t$TAGS{$tag}\n"; }
   	exit 0;
	}

	#--------------------------------------------------------------------
	my $results=$SCRIPT->mon_http_base(\%DESC);

	if ($VERBOSE) { 
		my $file_page = '/tmp/page.html';
		open (F,">$file_page");
		print F $results->{'body'};
		close F;
		delete $results->{'body'};
		print Dumper($results); 
	}

	#--------------------------------------------------------------------
	$SCRIPT->test_init($OOO,$TAGS{$OOO});
	$SCRIPT->test_init($OO1,$TAGS{$OO1});
	$SCRIPT->test_init($OO2,$TAGS{$OO2});
	$SCRIPT->test_init($OO3,$TAGS{$OO3});
	$SCRIPT->test_init($OO4,$TAGS{$OO4});
	$SCRIPT->test_init($OO5,$TAGS{$OO5});
	$SCRIPT->test_init($OO6,$TAGS{$OO6});
	$SCRIPT->test_done($OOO,$SCRIPT->err_num());
	$SCRIPT->test_done($OO1,$results->{'elapsed'});
	$SCRIPT->test_done($OO2,$results->{'size'});
	$SCRIPT->test_done($OO3,$results->{'pattern'});
	$SCRIPT->test_done($OO4,$results->{'rctype'});
	$SCRIPT->test_done($OO5,$results->{'nlinks'});
	$SCRIPT->test_done($OO6,$results->{'rc'});

}

$SCRIPT->print_metric_data();

