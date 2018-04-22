#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME:  linux_metric_ldap_auth.pl
# AUTHOR: <fmarin\@s30labs.com>
# DATE: 17/02/2018
# VERSION: 1.0
#
# DESCRIPTION:
# Monitoriza que el usuario especificado es validado por el servidor de LDAP 
# 0=OK | 1=UNK | 2=Error | 3=UNK
#
# USAGE:
# linux_metric_ldap_auth.pl -host 1.1.1.1 -user user1 -pwd mysecret
# linux_metric_ldap_auth.pl -host 1.1.1.1 [-port 1111] -user user1 -pwd mysecret -version 1
# linux_metric_ldap_auth.pl -host 1.1.1.1 [-port 1111] -secure -user user1 -pwd mysecret
# linux_metric_ldap_auth.pl -h  : Help
#
# -host       : Database Server Host
# -port       : Port (default 389)
# -user       : LDAP User
# -pwd        : LDAP User Password
# -version    : LDAP Version (default 3)
# -secure     : LDAP/LDAPS
# -v/-verbose : Verbose output (debug)
# -h/-help    : Help
#
# OUTPUT:
# <001> LDAP Auth Latency = 0.008458
# <002> LDAP Auth Status = 0
#
# </CNMDOCU>
#--------------------------------------------------------------------
MYHEADER
};
use lib '/opt/crawler/bin/';
use strict;
use warnings;
use Getopt::Long;
use CNMScripts;
use Data::Dumper;
use Time::HiRes qw(gettimeofday tv_interval);
use Net::LDAP;

#--------------------------------------------------------------------
#--------------------------------------------------------------------
my $script = CNMScripts->new();
my %opts = ();
my $ok=GetOptions (\%opts,  'h','help','v','verbose','user=s','pwd=s','port=s','host=s','version=s','secure' );
if (! $ok) {
	print STDERR "***ERROR EN EL PASO DE PARAMETROS***\n";	
	$script->usage($main::MYHEADER); 
	exit 1;
}

my $VERBOSE = ((defined $opts{'v'}) || (defined $opts{'verbose'})) ? 1 : 0;

if ( ($opts{'h'}) || ($opts{'help'})) { $script->usage($main::MYHEADER); }

my $host = ($opts{'host'}) ? $opts{'host'} : $script->usage($main::MYHEADER);

my $port = 389;
if ($opts{'secure'}) {
	$port = ((defined $opts{'port'}) && ($opts{'port'})=~/\d+/) ? $opts{'port'} : 636;
}
else {
	$port = ((defined $opts{'port'}) && ($opts{'port'})=~/\d+/) ? $opts{'port'} : 389;
}
#$script->port($port);

my $user = (defined $opts{'user'}) ? $opts{'user'} : '';
my $pwd = (defined $opts{'pwd'}) ? $opts{'pwd'} : '';
my $version = (defined $opts{'version'}) ? $opts{'version'} : 3;


if ($VERBOSE) {
   print "PARAMETERS *****\n";
   print Dumper (\%opts);
   print "ip=$host port=$port user=$user pwd=$pwd\n";
   print "*****\n";
}

#--------------------------------------------------------------------
my ($r,$data,$value) = ('','',2);
# $value => 0=OK | 1=UNK  | 2=Error en getToken | 3=Error en validateToken
$script->test_init('001', "LDAP Auth Latency");
$script->test_init('002', "LDAP Auth Status");



#--------------------------------------------------------------------
my $t0=[gettimeofday];

#--------------------------------------------------------------------
my $ldap = Net::LDAP->new( $host );

my $msg = $ldap->bind( $user, password => $pwd, version => $version );

my $t1=[gettimeofday];
my $elapsed = tv_interval ( $t0, $t1);
my $elapsed3 = sprintf("%.6f", $elapsed);
$script->test_done('001',$elapsed3);

my $code = $msg->code();
my $error = $msg->error();
if (($code == 0) && ($error=~/success/i)) { $value=0; }
else {
	$script->log('info',"**ERROR** host=$host port=$port user=$user pwd=$pwd [$code - $error]");

}
if ($VERBOSE) {
	print "***$msg --- $code -- $error\n";
}

$script->test_done('002',$value);
$script->print_metric_data();

exit 0;

