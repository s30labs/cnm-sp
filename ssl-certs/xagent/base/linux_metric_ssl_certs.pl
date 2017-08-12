#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_metric_ssl_certs.pl
#
# DESCRIPTION:
# Obtiene el tiempo en segs. que falta para que un certificado concreto caduque.
#
# CALLING SAMPLE:
# linux_metric_ssl_certs.pl -n 1.1.1.1 -p 443
#
# INPUT (PARAMS):
# a. IP remota
# b. Puerto remoto
#
# OUTPUT (STDOUT):
# <001> Seconds for expiration = 305763509
# <002> Days for expiration = 3538
#
# OUTPUT (STDERR):
# Error info, warnings etc... If verbose also debug info.
#
# EXIT CODE:
#  0: OK
# -1: System error
# >0: Script error
#--------------------------------------------------------------------------------------
use lib '/opt/crawler/bin/';
use strict;
use Time::Local;
use Getopt::Std;
use Data::Dumper;
use CNMScripts;

#--------------------------------------------------------------------------------------
my %MONTHS=('Jan'=>'0', 'Feb'=>'1', 'Mar'=>'2', 'Apr'=>'3', 
				'May'=>'4',	'Jun'=>'5', 'Jul'=>'6', 'Aug'=>'7',
				'Sep'=>'8', 'Oct'=>'9', 'Nov'=>'10', 'Dec'=>'11' );

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
linux_metric_ssl_certs.pl. $VERSION

$fpth[$#fpth] -n IP -p port -t type [-v]
$fpth[$#fpth] -h  : Ayuda

-n    IP/Host
-p    Port
-t		Protocol type (https|smtp|pop3|imap|ftp)
-v    Verbose
USAGE

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my %opts=();
getopts("hvn:p:t:",\%opts);

if ($opts{h}) { die $USAGE;}
my $REMOTE = $opts{n} || die $USAGE;
my $PORT = $opts{p} || die $USAGE;
my $PROTO_ARGS='';
if (exists $opts{t}) { 

	if (lc $opts{t} eq 'smtp') { $PROTO_ARGS = '-starttls smtp'; }
	elsif (lc $opts{t} eq 'pop3') { $PROTO_ARGS = '-starttls pop3'; }
	elsif (lc $opts{t} eq 'imap') { $PROTO_ARGS = '-starttls imap'; }
	elsif (lc $opts{t} eq 'ftp') { $PROTO_ARGS = '-starttls ftp'; }
}
my $VERBOSE=0;
if (exists $opts{v}) { $VERBOSE=1; }

my $script = CNMScripts->new();

my $temp_errors=`/bin/mktemp /var/tmp/cert_err.XXXXXX`;
chomp $temp_errors;
my $TIMEOUT=3;

#my $end_date=`/bin/echo | /usr/bin/openssl s_client -connect $REMOTE:$PORT 2>&1 | /bin/sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | /usr/bin/openssl x509 -noout -enddate`;
#my $cmd="/bin/echo | /usr/bin/openssl s_client -connect $REMOTE:$PORT 2>&1 | /bin/sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' 2>&1 | /usr/bin/openssl x509 -noout -enddate 2>&1";
my $cmd="/bin/echo | /usr/bin/timeout $TIMEOUT /usr/bin/openssl s_client -connect $REMOTE:$PORT $PROTO_ARGS 2>$temp_errors | /bin/sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' 2>$temp_errors | /usr/bin/openssl x509 -noout -text 2>$temp_errors";

my $res=`$cmd`;

my ($seconds_left, $days_left)=('U','U');

#Not After : Oct 18 23:59:59 2014 GMT
if ($res =~ /Not After\s*\:\s*(\w+)\s+(\d+)\s+(\d+)\:(\d+)\:(\d+)\s+(\d+)\s+GMT/) {
	my ($month,$mday,$hour,$min,$sec,$year)=($1,$2,$3,$4,$5,$6);
	$year -= 1900;

	my $time = timelocal($sec,$min,$hour,$mday,$MONTHS{$month},$year);
	#$ev="M=$month ($MONTHS{$month}),D=$mday,h=$hour,m=$min,s=$sec,YEAR=$year,TIME=$time\n";
	$seconds_left = $time-time();
	$days_left = int($seconds_left/86400);
}

print "<001> Seconds for expiration = $seconds_left\n";
print "<002> Days for expiration = $days_left\n";


my $ev = $script->slurp_file($temp_errors);

if ($VERBOSE) {
	print "\n\n\ncmd=$cmd\n**STDERR**\n$ev\n";
}

unlink $temp_errors;
exit 0;

