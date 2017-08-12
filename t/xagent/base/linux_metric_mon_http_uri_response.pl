#!/usr/bin/perl -w
#--------------------------------------------------------------------
# mon_http_uri_response
#--------------------------------------------------------------------
use lib "/opt/crawler/bin";
use Getopt::Long;
use Monitor;

#--------------------------------------------------------------------
# ESTE ES EL PATRON CON EL QUE SE COMPARA LA RESPUESTA PARA LA METRICA 005
#--------------------------------------------------------------------
my $PATTERN ='Error desconocido';

# Informacion ------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $USAGE = <<USAGE;
(c) fml

$fpth[$#fpth] -h : Ayuda
$fpth[$#fpth] -n host -u url [-t get|post -e extra_params -p port] : Chequea http
$fpth[$#fpth] -n host -u url -v [-t get|post -e extra_params -p port] : Chequea http y presenta la pagina

-h (-help): Ayuda
-v (-verbose): verbose

-u (-url): URL
-p (-port): port
-t (-type): type (get/post)
-e (extra): Extra parameters

-use_proxy: Utiliza proxy
-proxy_user: Usuario de proxy
-proxy_pwd: Clave del usuario del proxy
-proxy_host: Maquina Proxy
-proxy_port: puerto del proxy

-use_realm: Utiliza realm
-realm_user: Usuario del realm
-realm_pwd: Clave del usuario del realm

USAGE

# Parametros de entrada ---------------------------------------------
my %DESC=();
my %OPTS = ();
GetOptions (\%OPTS,  'h','help','v','verbose','n=s','u=s','url=s','p=s','port=s','t=s','type=s','e=s','extra=s','page=s',
                     'use_realm','realm_user=s','realm_pwd=s',
                     'use_proxy','proxy_user=s','proxy_pwd=s','proxy_host=s','proxy_port=s')
            or die "$0:[ERROR] en el paso de parametros. Si necesita ayuda ejecute $0 -help\n";


if ( ($OPTS{'help'}) || ($OPTS{'h'}) ) { die $USAGE; }
if (! $OPTS{'n'}) { die $USAGE; }

if ($OPTS{'u'}) { $OPTS{'url'} = $OPTS{'u'}; }
if ($OPTS{'p'}) { $OPTS{'port'} = $OPTS{'p'}; }
if ($OPTS{'t'}) { $OPTS{'type'} = $OPTS{'t'}; }
if ($OPTS{'e'}) { $OPTS{'extra'} = $OPTS{'e'}; }

if ($OPTS{'url'}) {
   $DESC{'url'}=$OPTS{'url'};
   #if ($OPTS{'url'} =~ /^\d+\.\d+\.\d+\.\d+$/) { $DESC{'url'}="http://$OPTS{url}";}
   if ($OPTS{'url'} !~ /^http/) { $DESC{'url'}="http://$OPTS{url}";}

	$DESC{'url'} =~ s/__HOST__/$OPTS{'n'}/;

	if ($OPTS{'url'} =~ /^https/) { $defport=443; }
   $DESC{'port'} = (defined $OPTS{'port'}) ? $OPTS{'port'} : $defport;
   $DESC{'url_type'} = (defined $OPTS{'type'}) ? uc $OPTS{'type'} : 'GET';
   $DESC{'params'} = (defined $OPTS{'extra'}) ? lc $OPTS{'extra'} : '';
}


else { die $USAGE;}

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



use Data::Dumper;
print Dumper(\%DESC);
print $OPTS{'n'} ."\n";
#--------------------------------------------------------------------
$DESC{nlinks}='U';

my $r=mon_http(\%DESC);

if ( ($OPTS{'v'}) || ($OPTS{'verbose'}) ) {
	if ($DESC{'rc'}) { print "RC=$DESC{rc}\n";  }
	if ($DESC{'rcstr'}) { print "RCSTR=$DESC{rcstr}\n";  }
	if ($DESC{'rcdata'}) { 
		print '-'x50 . "\n";
		print "RCDATA=$DESC{rcdata}\n";  
		print '-'x50 . "\n";
	}
	if ($DESC{'elapsed'}) { print "ELAPSED=$DESC{elapsed}\n";  }
	if ($DESC{'nlinks'}) { print "LINKS=$DESC{nlinks}\n";  }
}

my $rc_class='U';
if ($DESC{'rc'} ne 'U') { $rc_class=int ($DESC{'rc'}/100); }

my $is_pattern=0;
if (defined $PATTERN) {
	while ($DESC{'rcdata'} =~ /$PATTERN/g) { $is_pattern+=1; }
}

print '<001> Tiempo de respuesta = '.$DESC{elapsed}."\n";
print '<002> Codigo de error = '.$DESC{rc}."\n";
print '<003> Clase de codigo de error = '.$rc_class."\n";
print '<004> Numero de links = '.$DESC{nlinks}."\n";
print '<005> Coincidencias de la respuesta = '.$is_pattern."\n";
