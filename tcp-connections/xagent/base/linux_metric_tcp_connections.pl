#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME:  linux_metric_tcp_connections.pl
# AUTHOR:  fmarin\@s30labs.com
# DATE: 27/01/2015
# VERSION: 1.0
#
# DESCRIPTION:
# Obtiene metricas basadas en el contenido de una pagina WEB
#
# USAGE:
# linux_metric_tcp_connections.pl -id 1 -port 80
# linux_metric_tcp_connections.pl -ip 86.109.126.250 -sport 80,443
# linux_metric_tcp_connections.pl -n www -d s30labs.com -sport 8080
# linux_metric_tcp_connections.pl -name www -domain s30labs.com -port 8080
# linux_metric_tcp_connections.pl -h
#
# -id
#      ID del dispositivo sobre el que se ejecuta el script. Los dispositivos deben tenere definido un campo URL de tipo listaa con las URLs a monitorizar.
# -n, -name  
#      Nombre del dispositivo sobre el que se ejecuta el script. Los dispositivos deben tenere definido un campo URL de tipo listaa con las URLs a monitorizar.
# -d, -domain  
#      Dominio del dispositivo sobre el que se ejecuta el script. Los dispositivos deben tenere definido un campo URL de tipo listaa con las URLs a monitorizar.
# -sport
#      Puerto servidor.
# -cport
#      Puerto cliente.
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


# ------------------------------------------------------------------
my %DESC=();
my @ALL_URLS=();
my $host_name='';
my $log_level='info';
my %OPTS = ();
my $snmpcommunity = 'public';
my $snmpversion = '2c';
my $ip = 'localhost';
# Parametros de entrada ---------------------------------------------
GetOptions (\%OPTS,  'h','help','v','verbose','n=s','name=s','d=s','domain=s','u=s','url=s','p=s','sport=s','cport=s','t=s','type=s','l',
							'iid=s', 'pattern=s', 'ip=s',
                     'use_realm','realm_user=s','realm_pwd=s','id=s',
                     'use_proxy','proxy_user=s','proxy_pwd=s','proxy_host=s','proxy_port=s')
            or die "$0:[ERROR] en el paso de parametros. Si necesita ayuda ejecute $0 -help\n";

my $SCRIPT=CNMScripts->new();

if ( ($OPTS{'help'}) || ($OPTS{'h'}) ) { 
   $SCRIPT->usage($main::MYHEADER);
   exit 1;
}

if ((!$OPTS{'sport'}) && (!$OPTS{'cport'})){
   $SCRIPT->usage($main::MYHEADER);
   exit 1;
}
my @SPORTS = split (',', $OPTS{'sport'});
my @CPORTS = split (',', $OPTS{'cport'});
 
my $VERBOSE=0;
if ( ($OPTS{'verbose'}) || ($OPTS{'v'}) ) { $VERBOSE=1; }
$DESC{'verbose'} = $VERBOSE;

#--------------------------------------------------------------------
my %TAGS=( '000'=>'RC', '001'=>'Established', '002'=>'Listen', '003'=>"Time Wait", '004'=>'Other'  );
if ($OPTS{'l'}) {
   foreach my $tag (sort keys %TAGS) { print "<$tag>\t$TAGS{$tag}\n"; }
   exit 0;
}

my %SRESULT = ();
my %CRESULT = ();
foreach my $px (@SPORTS) { 
	my $p = 's'.$px;
	$SRESULT{$p} = {'001'=>0, '002'=>0, '003'=>0, '004'=>0}; 
}
foreach my $px (@CPORTS) { 
	my $p = 'c'.$px;
	$CRESULT{$p} = {'001'=>0, '002'=>0, '003'=>0, '004'=>0}; 
}
if ($VERBOSE) { print Dumper(\%SRESULT); }
if ($VERBOSE) { print Dumper(\%CRESULT); }
#--------------------------------------------------------------------
$SCRIPT->test_init('000',$TAGS{'000'});
$SCRIPT->test_done('000',1);
foreach my $px (sort @SPORTS) {
	my $p = 's'.$px;
   $SCRIPT->test_init("001.$p","$TAGS{'001'} in server port $px");
   $SCRIPT->test_init("002.$p","$TAGS{'002'} in server port $px");
   $SCRIPT->test_init("003.$p","$TAGS{'003'} in server port $px");
   $SCRIPT->test_init("004.$p","$TAGS{'004'} in server port $px");
   $SCRIPT->test_done("001.$p",0);
   $SCRIPT->test_done("002.$p",0);
   $SCRIPT->test_done("003.$p",0);
   $SCRIPT->test_done("004.$p",0);
}
foreach my $px (sort @CPORTS) {
	my $p = 'c'.$px;
   $SCRIPT->test_init("001.$p","$TAGS{'001'} in client port $px");
   $SCRIPT->test_init("002.$p","$TAGS{'002'} in client port $px");
   $SCRIPT->test_init("003.$p","$TAGS{'003'} in client port $px");
   $SCRIPT->test_init("004.$p","$TAGS{'004'} in client port $px");
   $SCRIPT->test_done("001.$p",0);
   $SCRIPT->test_done("002.$p",0);
   $SCRIPT->test_done("003.$p",0);
   $SCRIPT->test_done("004.$p",0);
}

#--------------------------------------------------------------------
if (	($OPTS{'id'}) || ($OPTS{'ip'}) || 
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

	if ($VERBOSE) { print Dumper($response); }

   if ($response->[0]->{'name'} eq '') {
      print STDERR "**ERROR** NO SE LOCALIZA EL DISPOSITIVO (class=$class endpoint=$endpoint)\n";
		$SCRIPT->log('info',"Termino...  NO SE LOCALIZA EL DISPOSITIVO (class=$class endpoint=$endpoint)");
		$SCRIPT->print_metric_data();
		exit 0;
   }

	if (exists $response->[0]->{'snmpversion'}) { 
		$snmpversion = $response->[0]->{'snmpversion'}; 
		if ($snmpversion == 2) { $snmpversion = '2c'; }
	}
	if (exists $response->[0]->{'snmpcommunity'}) { $snmpcommunity = $response->[0]->{'snmpcommunity'}; }
	$ip = $response->[0]->{'ip'};
}

elsif (! exists $OPTS{'l'}) {
   $SCRIPT->usage($main::MYHEADER);
   exit 1;
}

my $cmd="snmptable -v $snmpversion -c $snmpcommunity $ip tcpConnTable";
if ($VERBOSE) { print ">>> $cmd\n"; }
my @ALL_CONNECTIONS=`$cmd`;
if ($VERBOSE) { print Dumper(\@ALL_CONNECTIONS); }

#--------------------------------------------------------------------
foreach my $line (@ALL_CONNECTIONS) {

#tcpConnectionState OBJECT-TYPE
#    SYNTAX     INTEGER {
#                    closed(1),
#                    listen(2),
#                    synSent(3),
#                    synReceived(4),
#                    established(5),
#                    finWait1(6),
#                    finWait2(7),
#                    closeWait(8),
#                    lastAck(9),
#                    closing(10),
#                    timeWait(11),
#                    deleteTCB(12)
#                }

	chomp $line;
	$line=~s/^\s+(.+)$/$1/;
	my ($state,$srcip,$srcport,$destip,$destport) = split(/\s+/,$line);
	#5        192.168.57.9            38000    10.105.135.150            445

	my $p = 's'.$srcport;
	if (exists $SRESULT{$p}) {
		if ($state == 5) { $SRESULT{$p}->{'001'}++; }
		elsif ($state == 2) { $SRESULT{$p}->{'002'}++; }
		elsif ($state == 11) { $SRESULT{$p}->{'003'}++; }
		else { $SRESULT{$p}->{'004'}++; }
	}
	$p = 'c'.$destport; 
   if (exists $CRESULT{$p}) {
      if ($state == 5) { $CRESULT{$p}->{'001'}++; }
      elsif ($state == 2) { $CRESULT{$p}->{'002'}++; }
      elsif ($state == 11) { $CRESULT{$p}->{'003'}++; }
      else { $CRESULT{$p}->{'004'}++; }
   }
}

#--------------------------------------------------------------------
$SCRIPT->test_init('000',$TAGS{'000'});
$SCRIPT->test_done('000',$SCRIPT->err_num());
foreach my $px (sort keys %SRESULT) {
	my $p = $px;
	$SCRIPT->test_done("001.$p",$SRESULT{$p}->{'001'});
	$SCRIPT->test_done("002.$p",$SRESULT{$p}->{'002'});
	$SCRIPT->test_done("003.$p",$SRESULT{$p}->{'003'});
	$SCRIPT->test_done("004.$p",$SRESULT{$p}->{'004'});
}
foreach my $px (sort keys %CRESULT) {
	my $p = $px;
   $SCRIPT->test_done("001.$p",$CRESULT{$p}->{'001'});
   $SCRIPT->test_done("002.$p",$CRESULT{$p}->{'002'});
   $SCRIPT->test_done("003.$p",$CRESULT{$p}->{'003'});
   $SCRIPT->test_done("004.$p",$CRESULT{$p}->{'004'});
}

$SCRIPT->print_metric_data();

