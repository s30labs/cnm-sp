#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME:  linux_metric_www_stauts.pl
# AUTHOR:  fmarin\@s30labs.com
# DATE: 15/04/2021
# VERSION: 1.0
#
# DESCRIPTION:
# Obtiene el estado de una pagina WEB en funcion del codigo HTTP y del estado del dispositivo
#
# USAGE:
# linux_metric_www_base.pl -ip 86.109.126.250 -u http://www.s30labs.com
# linux_metric_www_base.pl -h
#
# -ip
#      IP del dispositivo al que se asocian los resultados y sobrel el cual se evalua el periodo de mantenimiento.
# -u, -url
#      URL sobre la que se hace la peticion
# -ok
#      Condicion para determinar el estado OK. Debe ser un codigo de respuesta HTTP
# -error
#      Condicion para determinar el estado ERROR. Debe ser un codigo de respuesta HTTP
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
my %STATUS = ( 'ok'=>0, 'error'=>0 );
my %OPTS = ();
GetOptions (\%OPTS,  'h','help','v','verbose','n=s','name=s','d=s','domain=s','u=s','url=s','p=s','port=s','t=s','type=s','l',
							'iid=s', 'pattern=s', 'ip=s', 'ok=s', 'error=s',
                     'use_realm','realm_user=s','realm_pwd=s','id=s',
                     'use_proxy','proxy_user=s','proxy_pwd=s','proxy_host=s','proxy_port=s')
            or die "$0:[ERROR] en el paso de parametros. Si necesita ayuda ejecute $0 -help\n";

my $SCRIPT=CNMScripts::WWW->new();

if ( ($OPTS{'help'}) || ($OPTS{'h'}) ) { 
   $SCRIPT->usage($main::MYHEADER);
   exit 1;
}

if ($OPTS{'ok'}) { $STATUS{'ok'} = $OPTS{'ok'}; }
elsif ($OPTS{'error'}) { $STATUS{'error'} = $OPTS{'error'}; }
else { 
   $SCRIPT->usage($main::MYHEADER);
   exit 1;
}

if (($OPTS{'u'}) || ($OPTS{'url'})) {

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
	
#--------------------------------------------------------------------
my $device_status = 0; # 0:active | 1:inactive | 2:maintenance
if ($OPTS{'ip'}) { $device_status = get_device_status($OPTS{'ip'}); }


foreach my $iid (@ALL_URLS) {

   $DESC{'url'}=$iid;

	#--------------------------------------------------------------------
	my ($OOO, $OO1, $OO2, $OO3, $OO4, $OO5, $OO6) = ("000.$iid", "001.$iid", "002.$iid", "003.$iid", "004.$iid", "005.$iid", "006.$iid");

	my %TAGS=( 

		$OOO=>'RC', $OO1=>'T (sgs)', $OO2=>'Size', $OO3=>'Status', $OO4=>'Return Code Type',  $OO5=>'Num. Links', $OO6=>'Return Code'

	);

	if ($OPTS{'l'}) {
   	foreach my $tag (sort keys %TAGS) { print "<$tag>\t$TAGS{$tag}\n"; }
   	exit 0;
	}

	#--------------------------------------------------------------------
	my $results=$SCRIPT->mon_http_base(\%DESC);

	if ($VERBOSE) { print Dumper($results); }

	#--------------------------------------------------------------------
	# 0  -> Activo y OK
	# 1  -> Activo y Error
	# 10 -> No activo y OK
	# 11 -> No activo y Error
	my $STAT = 0;
	if ($STATUS{'ok'} > 0) {
		if ($results->{'rc'} eq $STATUS{'ok'}) { $STAT = 0; }
		else { $STAT = 1; }
	}
	elsif ($STATUS{'error'} > 0) {
		if ($results->{'rc'} eq $STATUS{'error'}) { $STAT = 1; }
		else { $STAT = 0; }
   }
	if ($device_status > 0) { $STAT += 10; }

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
	$SCRIPT->test_done($OO3,$STAT);
	$SCRIPT->test_done($OO4,$results->{'rctype'});
	$SCRIPT->test_done($OO5,$results->{'nlinks'});
	$SCRIPT->test_done($OO6,$results->{'rc'});

}

$SCRIPT->print_metric_data();

#--------------------------------------------------------------------
# status = 0 (active) | 1 (removed) | 2 (maintenance)
sub get_device_status {
my ($ip) = @_;

   my $host_ip = 'localhost';
   my $log_level = 'info';

   my $api=CNMScripts::CNMAPI->new( 'host'=>$host_ip, 'timeout'=>10, 'log_level'=>$log_level );
   my ($user,$pwd)=('admin','cnm123');
   my $sid = $api->ws_get_token($user,$pwd);
   if ($VERBOSE) { print "sid=$sid\n"; }

   my $class='devices';
   my $endpoint=$ip.'.json';

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

   return $STATUS;
}

