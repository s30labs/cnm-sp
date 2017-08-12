#!/usr/bin/perl
# -----------------------------------------------------------------------------------
# linux_metric_dns_check.pl
# -----------------------------------------------------------------------------------
# Valida que se resuelve correctamente el nombre DNS de un equipo.
# Otra cosa es validar que un servidor DNS responde => Resuelve nombres de uno o varios dominios precargados
# 
# <001> DNS1 Latency = 0.011817
# <002> DNS2 Latency = 0.010426
# <101> DNS1 TTL = 6357
# <102> DNS2 TTL = 5739
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
my %opts=();
getopts('hbn:s:t:',\%opts);

if ($opts{h}) { usage();}
if ((! exists $opts{n}) || (!$opts{n})) { usage();}

my ($TIMEOUT,$host)=(3,$opts{n});
if ((exists $opts{t}) && ($opts{t}=~/\d+/)) { $TIMEOUT=$opts{t};}

my @dns_servers = ('8.8.8.8', '8.8.4.4'); #Google
if (exists $opts{s}) { @dns_servers = split (',', $opts{s}); }

# -----------------------------------------------------------------------------------
my $script = CNMScripts->new();
if ($opts{n}=~/\d+\.\d+\.\d+\.\d+/) { $host=$script->get_name_from_ip($opts{n}); } 

$script->log('info',"host=$host servers=@dns_servers");
print "host=$host servers=@dns_servers\n";

# -----------------------------------------------------------------------------------
my %desc=();
$desc{'rr'}=$host;

my @res=();
foreach my $ip (@dns_servers) {
   $desc{'host_ip'}=$ip;
   mon_dns(\%desc);
   push @res, {'ttl'=>$desc{'ttl'}, 'elapsed'=>$desc{'elapsed'}, 'rcdata'=>$desc{'rcdata'}, 'dns'=>$ip};
}


foreach my $i (1..scalar(@dns_servers)) {

	my $tag_latency=sprintf("%03d",$i);

	$script->test_init($tag_latency, "DNS$i ($dns_servers[$i-1]) Latency");
	$script->test_done($tag_latency, $res[$i-1]->{'elapsed'});

	my $tag_ttl=sprintf("%03d",$i+100);
	$script->test_init($tag_ttl, "DNS$i ($dns_servers[$i-1]) TTL");
	$script->test_done($tag_ttl, $res[$i-1]->{'ttl'});
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

$fname -n IP/Host -p port [-t timeout]
$fname -h

-n    Host (Nombre a resolver)
-s    Servidor/es DNS utilizados
-t 	Timeout (opcional)
-b		Genera alerta azul
-h    Ayuda
USAGE

   die $USAGE;

}

