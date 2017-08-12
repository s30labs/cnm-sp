#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_metric_route_tag.pl
#
# DESCRIPTION:
# Obtiene los saltos necesarios para llegar a una IP destino y genera un id numerico
# a partir de un hash MD5. Esto permite detectar cambios de ruta
#
# CALLING SAMPLE:
# linux_metric_route_tag.pl -host 1.1.1.1
#
# INPUT (PARAMS):
# a. -host :	IP remota
#
# OUTPUT (STDOUT):
# <001> Route Tag = 317488
# <002> Number of Hops = 1
#
# OUTPUT (STDERR):
# Error info, warnings etc... If verbose also debug info.
#
# EXIT CODE:
#  0: OK
# -1: System error
# >0: Script error
#--------------------------------------------------------------------------------------
use strict;
#use Time::Local;
use Digest::MD5 qw(md5_hex);
use Data::Dumper;
use Getopt::Long;

#--------------------------------------------------------------------------------------
my $ERR=0;
my $ERRSTR='';
my $VERBOSE=0;

#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $USAGE = <<USAGE;
(c) s30labs by fml

$fpth[$#fpth] -h : Ayuda
$fpth[$#fpth] -host=1.1.1.1

-v:      Verbose
-h (-help): Ayuda

-host: 	Host destino
USAGE

my %OPTS = ();
GetOptions (\%OPTS,  'h','help','v','verbose','host=s')
            or die "$0:[ERROR] en el paso de parametros. Si necesita ayuda ejecute $0 -help\n";


if ( ($OPTS{'help'}) || ($OPTS{'h'}) ) { die $USAGE; }
if ( ($OPTS{'verbose'}) || ($OPTS{'v'}) ) { $VERBOSE=1; }

#--------------------------------------------------------------------------------------
my $REMOTE_IP = $OPTS{'host'} || die $USAGE;
my $CMD="/usr/sbin/traceroute -T $REMOTE_IP";
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
#cnm-devel2:/opt/data/xagent/base/metrics# traceroute -T www.cisco.com
#traceroute to www.cisco.com (84.53.128.170), 30 hops max, 60 byte packets
# 1  10.2.254.252 (10.2.254.252)  0.412 ms  0.432 ms  0.484 ms
# 2  dsldevice.domain.name (192.168.1.254)  1.447 ms  1.993 ms  2.871 ms
# 3  143.Red-80-58-67.staticIP.rima-tde.net (80.58.67.143)  42.665 ms  45.130 ms  47.671 ms
# 4  189.Red-80-58-94.staticIP.rima-tde.net (80.58.94.189)  51.120 ms  52.871 ms  55.367 ms
# 5  110.Red-80-58-80.staticIP.rima-tde.net (80.58.80.110)  57.857 ms  59.543 ms  61.895 ms
# 6  * * *
# 7  * * *
# 8  * * *
# 9  84.53.128.170 (84.53.128.170)  44.670 ms  40.592 ms  42.524 ms

my @res=`$CMD 2>&1`;
my @ips=();
my $nhops=0;
foreach my $l (@res) {
	chomp $l;
	if ($l=~/^traceroute to/) { next; }
	if ($l=~/\((\d+\.\d+\.\d+\.\d+)\)/) { 
		push @ips, $1; 
		$nhops+=1;
	}
}
my $seq = join ('|',@ips);
my $tag1=md5_hex($seq);
my $tag=substr $tag1,0,8;
my $tagn = hex $tag;
$tagn=int($tagn/10000);
print "<001> Route Tag = $tagn\n";
print "<002> Number of Hops = $nhops\n";
#print "SEQ=$seq\n";

#--------------------------------------------------------------------------------------
#print Dumper($status);

