#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_app_ssl_certs.pl
#
# DESCRIPTION:
# Obtiene el tiempo en segs. que falta para que un certificado concreto caduque.
#
# CALLING SAMPLE:
# linux_app_ssl_certs.pl -n 1.1.1.1 -p 443
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
use JSON;

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
linux_app_ssl_certs.pl. $VERSION

$fpth[$#fpth] -n IP -p port -t type [-v]
$fpth[$#fpth] -h  : Ayuda

-n    IP/Host
-p    Port
-s		Service Name
-t		Protocol type (https|smtp|pop3|imap|ftp)
-v    Verbose
USAGE

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my %opts=();
getopts("hvn:p:t:s:",\%opts);

if ($opts{h}) { die $USAGE;}
my $REMOTE = $opts{n} || die $USAGE;
my $PORT = $opts{p} || die $USAGE;

my $SERVICE_NAME='';
if (exists $opts{s}) { $SERVICE_NAME=$opts{s}; }

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

my $ip_list = CNMScripts->expand_subnet($REMOTE);
#print "REMOTE=$REMOTE==\n";
#print "@$ip_list\n";
#print @$ip_list."\n";
#exit;

my $TIMEOUT=3;
my @CERT_LIST=();
foreach my $ip (@$ip_list) {

   my %cert_info = ( 'ip'=>$ip, 'version'=>'U', 'serial_number'=>'U', 'signature_algorithm'=>'U', 'issuer'=>'U', 'start'=>'U', 'end'=>'U', 'PKAlgorithm'=>'U', 'PKlength'=>'U', );

	my $temp_errors=`/bin/mktemp /var/tmp/cert_err.XXXXXX`;
	chomp $temp_errors;

	#Set TLS extension servername in ClientHello
	my $servername='';
	if ($SERVICE_NAME ne '') { $servername="-servername $SERVICE_NAME"; }

	my $cmd0="/bin/echo | /usr/bin/timeout $TIMEOUT /usr/bin/openssl s_client $servername -connect $ip:$PORT $PROTO_ARGS 2>/dev/null | /bin/sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' 2>/dev/null ";
	$cert_info{'pem'}=`$cmd0`;
	chomp $cert_info{'pem'};

	my $cmd1="/bin/echo | /usr/bin/timeout $TIMEOUT /usr/bin/openssl s_client $servername -connect $ip:$PORT $PROTO_ARGS 2>$temp_errors | /bin/sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' 2>$temp_errors | /usr/bin/openssl x509 -noout -text 2>$temp_errors";
   my $res=`$cmd1`;

	if ($res =~ /Version\:\s*(\d+)/) { $cert_info{'version'} = $1; }
	if ($res =~ /Serial Number\:\n\s*(\w+\:.*+)\s+/m) { $cert_info{'serial_number'} = $1; }
	if ($res =~ /Signature Algorithm\:\s*(\w+)/) { $cert_info{'signature_algorithm'} = $1; }
	if ($res =~ /Issuer\:\s*(.+)\n\s*Validity/m) { $cert_info{'issuer'} = $1; }
	if ($res =~ /Validity\n\s*Not Before\:\s*(.+)\n\s*Not After\s*\:\s*(.+)\n/m) { $cert_info{'start'} = $1; $cert_info{'end'} = $2; }
	if ($res =~ /Subject\:\s*(.+)$/m) { $cert_info{'subject'} = $1; }
	if ($res =~ /Subject Public Key Info\:\n\s*Public Key Algorithm\:\s*(\w+)\n\s*RSA Public Key\:\s*\((\d+)\s*\w*\)\n/m) { $cert_info{'PKAlgorithm'} = $1; $cert_info{'PKlength'} = $2; }

	$cert_info{'ev'} = $script->slurp_file($temp_errors);
	push @CERT_LIST, \%cert_info;

	if ($VERBOSE) {
   	print "\n\n\ncmd=$cmd0 | /usr/bin/openssl x509 -noout -text\n**STDERR**\n$cert_info{'ev'}\n";
		print Dumper(\%cert_info);
	}

	unlink $temp_errors;
}


#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my @COL_MAP = (
	{ 'label'=>'IP', 'width'=>'16' , 'name_col'=>'ip',  'sort'=>'ipaddr', 'align'=>'left', 'filter'=>'#select_filter' },
   { 'label'=>'Version', 'width'=>'7' , 'name_col'=>'version',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   { 'label'=>'Serial Number', 'width'=>'20' , 'name_col'=>'serial_number',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'Signature Algorithm', 'width'=>'18' , 'name_col'=>'signature_algorithm',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   { 'label'=>'Issuer', 'width'=>'35' , 'name_col'=>'issuer',  'sort'=>'int', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'Subject', 'width'=>'35' , 'name_col'=>'subject',  'sort'=>'int', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'Start Date', 'width'=>'17' , 'name_col'=>'start',  'sort'=>'int', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'End Date', 'width'=>'17' , 'name_col'=>'end',  'sort'=>'int', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'PK Algorithm', 'width'=>'15' , 'name_col'=>'PKAlgorithm',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   { 'label'=>'PK Length', 'width'=>'7' , 'name_col'=>'PKlength',  'sort'=>'text', 'align'=>'left', 'filter'=>'#select_filter' },
   { 'label'=>'PEM', 'width'=>'35' , 'name_col'=>'pem',  'sort'=>'int', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'EV', 'width'=>'35' , 'name_col'=>'ev',  'sort'=>'int', 'align'=>'left', 'filter'=>'#text_filter' },
);

my $data=encode_json(\@CERT_LIST);
print "$data\n";

my $col_map=encode_json(\@COL_MAP);
print "$col_map\n";

exit 0;

