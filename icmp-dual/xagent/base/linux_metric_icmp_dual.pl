#!/usr/bin/perl -w
#---------------------------------------------------------------------
# mon_icmp_dual
#---------------------------------------------------------------------
# Monitoriza si hay conectividad con dos direcciones IP diferentes.
# Devuelve un valor numerico que representa el estado en funcion los resultados.
# La tabla de decision es:
#
#	IP1	IP2	VALOR DEVUELTO
#	0		0		3	(No se accede ninguna de las dos)
#	0		1		2	(Se accede a IP2, No se accede a IP1)
#	1		0		1	(Se accede a IP1, No se accede a IP2)
#	1		1		0	(Se accede a las dos)
#					4  (Desconocido)		
#
# Los parametros de entrada son:
# -n	Host (es IP1)
# -s 	Nombre del campo de usuario que contiene IP2
#---------------------------------------------------------------------
use lib "/opt/crawler/bin";
use Getopt::Std;
use Monitor;
use Crawler::CNMAPI;
use Data::Dumper;
use JSON;

#---------------------------------------------------------------------
my $VERSION='1.0';

#---------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $USAGE = <<USAGE;
mon_icmp_dual $VERSION

Monitoriza si hay conectividad con dos direcciones IP diferentes.
Devuelve un valor numerico que representa un estado en funcion los resultados.
La tabla de decision es:

IP1   IP2   VALOR DEVUELTO
0     0     3  (No se accede ninguna de las dos)
0     1     2  (Se accede a IP2, No se accede a IP1)
1     0     1  (Se accede a IP1, No se accede a IP2)
1     1     0  (Se accede a las dos)
            4  (Desconocido)

$fpth[$#fpth] -h : Ayuda
$fpth[$#fpth] -n host -s Campo_de_Usuario_con_IP2 [-b] : Chequea servicio ICMP 

-n   IP (IP1)
-s   Nombre del campo de usuario que contiene (IP2)
-b	  Genera alertas azules cuando no hay respuesta. Si es asi devuelve el valor U. 
-h   Help
USAGE

#---------------------------------------------------------------------
my %opts=();
getopts("hs:n:",\%opts);

if ($opts{h}) { die $USAGE;}
if ( (! exists $opts{n}) || (! exists $opts{s}) ) { die $USAGE; }
if ( ($opts{n} eq '') || ($opts{s} eq '')) { die $USAGE; }

#---------------------------------------------------------------------
my ($rc, $ip1,$ip2,$elapsed1,$elapsed2,$status) = (0, $opts{n}, 'U', 'U', 'U', 4);

#---------------------------------------------------------------------
my $api=Crawler::CNMAPI->new( 'host'=>'localhost', 'timeout'=>10, 'log_level'=>'info' );
$api->ws_get_token();
$rc = $api->err_num();
if ($rc>0) {
	print STDERR 'ERROR: '.$api->err_str()."\n"; 
	print_results($ip1,$ip2,$elapsed1,$elapsed2,$status);
	exit ($rc)
}

my $class='devices';
my $endpoint=$opts{n}.'.json';
my $response = $api->ws_get($class,$endpoint);
$rc = $api->err_num();
if ($rc>0) {
   print STDERR 'ERROR: '.$api->err_str()."\n";
	print_results($ip1,$ip2,$elapsed1,$elapsed2,$status);
   exit ($rc)
}

$ip2 = $response->[0]->{$opts{s}};

#---------------------------------------------------------------------
my %DESC1 = ('host_ip'=>$ip1);
my $r1=mon_icmp(\%DESC1);
my %DESC2 = ('host_ip'=>$ip2);
my $r2=mon_icmp(\%DESC2);

#---------------------------------------------------------------------
if (($DESC1{'elapsed'} ne 'U') && ($DESC2{'elapsed'} ne 'U')) { $status=0; }
elsif (($DESC1{'elapsed'} eq 'U') && ($DESC2{'elapsed'} eq 'U')) { $status=3; }
elsif ($DESC1{'elapsed'} eq 'U') { $status=2; }
elsif ($DESC2{'elapsed'} eq 'U') { $status=1; }


print_results($ip1,$ip2,$DESC1{'elapsed'},$DESC2{'elapsed'},$status);

exit($rc);

#---------------------------------------------------------------------
#---------------------------------------------------------------------
sub print_results {
my ($ip1,$ip2,$elapsed1,$elapsed2,$status) = @_;

my $total ='U'; 
if (($elapsed1=~/[\d+|\.*]+/) && ($elapsed2=~/[\d+|\.*]+/)) { $total = $elapsed1+$elapsed2; }
elsif ($elapsed1=~/[\d+|\.*]+/) { $total = $elapsed1; }
elsif ($elapsed2=~/[\d+|\.*]+/) { $total = $elapsed2; }

if (! $opts{b})  { 
	if ($elapsed1 eq 'U') { $elapsed1=0; }
	if ($elapsed2 eq 'U') { $elapsed2=0; }
	if ($total eq 'U') { $total=0; }
}

print "<001.ip1> Lapse $ip1 = $elapsed1\n";
print "<001.ip2> Lapse $ip2 = $elapsed2\n";
print "<002> Lapse Total = $total\n";
print "<003> Status = $status\n";

}

