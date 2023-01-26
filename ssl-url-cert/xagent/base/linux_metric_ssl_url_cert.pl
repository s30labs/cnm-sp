#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME: linux_metric_ssl_url_cert.pl
# AUTHOR: Fernando Marin <fmarin\@s30labs.com>
# DATE: 27/07/2020
# VERSION: 1.0
#
# DESCRIPTION:
# Gets the expiration time of a web certificate in days
#
# USAGE:
# linux_metric_ssl_url_cert.pl
# linux_metric_ssl_url_cert.pl -host 1.1.1.1 -url https://www.cisco.com [-v]
# linux_metric_ssl_url_cert.pl -help
#
# -help : Help
# -v    : Verbose mode
# -host : For metric association only
# -url  : URI
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
use Time::Local;
use Data::Dumper;
use CNMScripts;

#--------------------------------------------------------------------------------------
my %OPTS = ();
my $SCRIPT=CNMScripts->new();
GetOptions (\%OPTS, 'in=s', 'help', 'v', 'host=s', 'url=s' ) or die "$0: Parameter error. If you need help execute $0 -help\n";

if ($OPTS{'help'}) {
   $SCRIPT->usage($main::MYHEADER);
   exit 1;
}

my $VERBOSE = (defined $OPTS{'v'}) ? 1: 0;
my $HOST = (defined $OPTS{'host'}) ? $OPTS{'host'} : '127.0.0.1';

if (! defined $OPTS{'url'}) {
   $SCRIPT->usage($main::MYHEADER);
   exit 1;
}

if ($VERBOSE) { print Dumper(\%OPTS); }
my $URL=$OPTS{'url'};

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my $cmd = "curl -vIk $URL 2>&1";
my $res = `$cmd`;

if ($VERBOSE) { 
	print '-'x50,"\n";
	print "$cmd\n";
	print "$res\n";
	print '-'x50,"\n";
}

$res =~ s/\r/ /g;
$res =~ s/\n/ /g;

my ($seconds_left, $days_left)=('U','U');
# CASO1: curl devuelve error
#curl: (6) Could not resolve host: xxxx
#curl: (60) SSL certificate problem: certificate has expired
my $error_code=0;
if ($res =~ /curl\:\s+\((\d+)\)/) {
	$error_code=$1;
	if ($VERBOSE) { print "**ERROR ($1)**\n"; }
	if ($error_code == 60) { ($seconds_left, $days_left)=(0,0);} 
}
elsif ($res =~ /Server certificate\:.*?start date\:.*?expire date\: (\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/) {
   my ($year,$month,$mday,$hour,$min,$sec)=($1,$2,$3,$4,$5,$6);
	if ($VERBOSE) { print "EXPIRE DATE >> $year,$month,$mday,$hour,$min,$sec---\n"; }

   $year -= 1900;
	$month -=1;

   my $time = timelocal($sec,$min,$hour,$mday,$month,$year);
   $seconds_left = $time-time();
   $days_left = int($seconds_left/86400);
}

##* Server certificate:
#*        subject: CN=xxxxxxx.com
#*        start date: 2020-06-29 13:47:18 GMT
#*        expire date: 2020-09-27 13:47:18 GMT
#*        subjectAltName: www.xxxxxxxxxxx.com matched
#*        issuer: C=US; O=Let's Encrypt; CN=Let's Encrypt Authority X3
#*        SSL certificate verify ok.


print "<001> Seconds for expiration = $seconds_left\n";
print "<002> Days for expiration = $days_left\n";

exit 0;

