#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME: linux_metric_ssl_url_cert.pl
# AUTHOR: Fernando Marin <fmarin\@s30labs.com>
# DATE: 27/07/2020
# VERSION: 2.0
#
# DESCRIPTION:
# Gets the expiration time of a web certificate in days
#
# USAGE:
# linux_metric_ssl_url_cert.pl
# linux_metric_ssl_url_cert.pl -host 1.1.1.1 -url https://www.cisco.com [-v]
# linux_metric_ssl_url_cert.pl -host 1.1.1.1 -url https://host:8443 -timeout 10
# linux_metric_ssl_url_cert.pl -help
#
# -help    : Help
# -v       : Verbose mode
# -host    : For metric association only
# -url     : URI
# -timeout : Segundos para el handshake TLS (por defecto 10)
#
# </CNMDOCU>
#--------------------------------------------------------------------
MYHEADER
};
use lib "/opt/crawler/bin", "/opt/crawler/bin/support";
use strict;
use warnings;
use Getopt::Long;
use CNMScripts;
use Time::Local qw(timelocal timegm);
use File::Temp qw(tempfile);
use Data::Dumper;

#--------------------------------------------------------------------------------------
my %OPTS = ();
my $SCRIPT=CNMScripts->new();
GetOptions (\%OPTS, 'in=s', 'help', 'v', 'host=s', 'url=s', 'timeout=s' )
   or die "$0: Parameter error. If you need help execute $0 -help\n";

if ($OPTS{'help'}) {
   $SCRIPT->usage($main::MYHEADER);
   exit 1;
}

my $VERBOSE = (defined $OPTS{'v'}) ? 1: 0;
my $HOST = (defined $OPTS{'host'}) ? $OPTS{'host'} : '127.0.0.1';
my $TIMEOUT = (defined $OPTS{'timeout'} && $OPTS{'timeout'} =~ /^\d+$/ && $OPTS{'timeout'} > 0)
              ? $OPTS{'timeout'} : 10;

if (! defined $OPTS{'url'}) {
   $SCRIPT->usage($main::MYHEADER);
   exit 1;
}

if ($VERBOSE) { print Dumper(\%OPTS); }
my $URL=$OPTS{'url'};

#--------------------------------------------------------------------------------------
# Caducidad del certificado del servidor.
#
# Se le pregunta a OpenSSL en vez de raspar la salida -v de curl. Esa salida es texto
# de depuracion para humanos y NO es un interfaz: cambio de formato entre curl 7.x
# ("expire date: 2027-01-20 09:27:18 GMT") y curl 8.x ("expire date: Jan 20 09:27:18
# 2027 GMT"), y con ello la metrica se quedo en U al migrar a Debian 13. El formato de
# 'notAfter=' de 'openssl x509' si esta documentado y es estable desde siempre.
#
# Ademas esto es una sonda TLS, no HTTP: no hay peticion HEAD, asi que le da igual
# HTTP/2, ALPN, redirecciones y los WAF que limitan los HEAD.
#
# IMPORTANTE: igual que el 'curl -k' anterior, NO se exige que la cadena valide. Se
# quiere medir la caducidad incluso con un certificado autofirmado o con la cadena
# incompleta. Por eso no se usa -verify_return_error.
#--------------------------------------------------------------------------------------
my ($seconds_left, $days_left) = ('U','U');
my $motivo = '';

#--- 1 - host y puerto, extraidos del URL -------------------------------------------
# Se acepta userinfo (user:pwd@) y literal IPv6, y se EXIGE que el nombre encaje en
# una lista blanca: ese valor acaba dentro de una orden de shell.
my ($scheme,$tls_host,$tls_port) = ('','',0);
if ($URL =~ m{^(https?)://(?:[^/\@]*\@)?(?:\[([^\]]+)\]|([^/:?\#]+))(?::(\d+))?}i) {
   $scheme   = lc($1);
   $tls_host = defined($2) ? $2 : $3;
   $tls_port = $4 ? $4 : 443;
}

my $es_ipv6 = ($tls_host =~ /:/) ? 1 : 0;
my $es_ip   = $es_ipv6 || ($tls_host =~ /^\d{1,3}(?:\.\d{1,3}){3}$/);
my $host_ok = $es_ipv6 ? ($tls_host =~ /^[0-9A-Fa-f:.]+$/)
                       : ($tls_host =~ /^[A-Za-z0-9](?:[A-Za-z0-9._-]*[A-Za-z0-9])?$/);

if    ($tls_host eq '')    { $motivo = "URL no interpretable: $URL"; }
elsif ($scheme ne 'https') { $motivo = "el URL no es https ($scheme): no hay certificado"; }
elsif (! $host_ok)         { $motivo = "nombre de host no valido: $tls_host"; }
elsif ($tls_port < 1 || $tls_port > 65535) { $motivo = "puerto fuera de rango: $tls_port"; }

#--- 2 - el handshake ----------------------------------------------------------------
# 'timeout' acota la orden: openssl s_client NO tiene timeout propio, y un servidor
# que acepta el TCP y no completa el handshake colgaria el proceso indefinidamente
# (medido: a los 8 s seguia esperando). Es la familia de REV-CNM-04 6.8.
my $out = '';
my $errfile = '';
if (! $motivo) {
   my $conecta = $es_ipv6 ? "[$tls_host]:$tls_port" : "$tls_host:$tls_port";
   # SNI SOLO con nombre: enviar una IP en server_name no es conforme y hay
   # servidores que lo rechazan.
   my $sni = $es_ip ? '' : " -servername '$tls_host'";

   (my $fh, $errfile) = tempfile('/tmp/sslurlcert.XXXXXXXX', UNLINK => 1);
   close $fh;

   my $cmd = "timeout $TIMEOUT openssl s_client -connect '$conecta'$sni </dev/null 2>'$errfile'"
           . " | openssl x509 -noout -enddate 2>>'$errfile'";

   if ($VERBOSE) { print '-'x50,"\n$cmd\n",'-'x50,"\n"; }
   $out = `$cmd`;

   if ($VERBOSE && -s $errfile) {
      if (open(my $e,'<',$errfile)) { print "== salida de openssl ==\n", <$e>; close $e; }
   }
   if ($out !~ /notAfter=/) { $motivo = "no se obtuvo el certificado de $conecta"; }
}

#--- 3 - notAfter=Jan 20 09:27:18 2027 GMT -------------------------------------------
# El dia va con relleno de espacio cuando es de una cifra: "notAfter=Feb  1 ...".
if (! $motivo) {
   my %MESES=(Jan=>1,Feb=>2,Mar=>3,Apr=>4,May=>5,Jun=>6,
              Jul=>7,Aug=>8,Sep=>9,Oct=>10,Nov=>11,Dec=>12);
   if ($out =~ /^notAfter=(\w{3})\s+(\d{1,2})\s+(\d{2}):(\d{2}):(\d{2})\s+(\d{4})\s+GMT/m) {
      my ($mes_txt,$mday,$hour,$min,$sec,$year) = ($1,$2,$3,$4,$5,$6);
      my $month = $MESES{$mes_txt};
      if (! defined $month) { $motivo = "mes no reconocido en notAfter: $mes_txt"; }
      else {
         if ($VERBOSE) { print "EXPIRE DATE >> $year,$month,$mday,$hour,$min,$sec GMT\n"; }
         # timegm, NO timelocal: la validez del certificado viene en GMT. Con
         # timelocal el resultado llevaba un error sistematico de 1-2 horas.
         my $time = timegm($sec,$min,$hour,$mday,$month-1,$year-1900);
         $seconds_left = $time - time();
         $days_left    = int($seconds_left/86400);
      }
   }
   else { $motivo = "notAfter con formato inesperado"; }
}

#--- 4 - veredicto --------------------------------------------------------------------
# Un fallo NO es "caduca hoy": se deja U, que en RRD es un hueco. Poner 0 dispararia
# la alarma de caducidad por un problema de red o de DNS.
if ($motivo) { print STDERR "**AVISO** $motivo\n"; }

print "<001> Seconds for expiration = $seconds_left\n";
print "<002> Days for expiration = $days_left\n";

exit 0;

