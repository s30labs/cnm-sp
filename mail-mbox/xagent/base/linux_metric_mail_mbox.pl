#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME:  linux_metric_mail_mbox.pl
# AUTHOR: <fmarin\@s30labs.com>
# DATE: 26/03/2018
# VERSION: 1.0
#
# DESCRIPTION:
# Monitoriza que se transfieren correctamente ficheros al servidor especificado
# 0=OK | 1=UNK | 2=Error | 3=UNK
#
# USAGE:
# linux_metric_mail_mbox.pl -host outlook.office365.com -port 995 -proto imap -ssl -user user\@domain.com -pwd xxx
# linux_metric_mail_mbox.pl -host outlook.office365.com -port 993 -proto pop -ssl -user user\@domain.com -pwd xxx
# linux_metric_mail_mbox.pl -h  : Help
#
# -host       : POP/IMAP Server Host
# -proto	     : imap/pop protocol (default imap)
# -port       : Port (default 993 - imaps)
# -user       : User
# -pwd        : Password
# -ssl        : If set uses SSL protocol
# -mailbox    : User mailbox (default INBOX)
# -timeout    : Connection timeout (default 2)
# -v/-verbose : Verbose output (debug)
# -h/-help    : Help
#
# OUTPUT:
# <001> Latency (sg) = 0.768299
# <002> Mails in mailbox = 7
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
use Net::IMAP::Simple;
use Mail::POP3Client;

#--------------------------------------------------------------------
#--------------------------------------------------------------------
my $script = CNMScripts->new();
my %opts = ();
my $ok=GetOptions (\%opts,  'h','help','v','verbose','user=s','pwd=s','port=s','host=s','proto=s','ssl','mbox=s','timeout=s' );
if (! $ok) {
	print STDERR "***ERROR EN EL PASO DE PARAMETROS***\n";	
	$script->usage($main::MYHEADER); 
	exit 1;
}

my $VERBOSE = ((defined $opts{'v'}) || (defined $opts{'verbose'})) ? 1 : 0;

if ( ($opts{'h'}) || ($opts{'help'})) { $script->usage($main::MYHEADER); }

my $host = ($opts{'host'}) ? $opts{'host'} : $script->usage($main::MYHEADER);
my $user = (defined $opts{'user'}) ? $opts{'user'} : '';
my $pwd = (defined $opts{'pwd'}) ? $opts{'pwd'} : '';
my $proto = (defined $opts{'proto'}) ? $opts{'proto'} : 'imap';
my $port = (defined $opts{'port'}) ? $opts{'port'} : '993';
my $mailbox = (defined $opts{'mailbox'}) ? $opts{'mailbox'} : 'INBOX';
my $use_ssl = (defined $opts{'ssl'}) ? 1 : 0;
my $timeout = (defined $opts{'timeout'}) ? $opts{'timeout'} : 2;
 
#$script->port($port);

if ($VERBOSE) {
   print "PARAMETERS *****\n";
   print Dumper (\%opts);
   print "ip=$host port=$port user=$user pwd=$pwd\n";
   print "*****\n";
}

#--------------------------------------------------------------------
$script->test_init('001', "Latency (sg)");
$script->test_init('002', "Mails in mailbox");
$script->test_init('003', "Response Code");



#--------------------------------------------------------------------
my $t0=[gettimeofday];
# No se inicializa a 'U' para evitar alertas azules.
# Si falla se usa el tag '003'
my ($lapse,$num_msgs,$RC,$ev)=(0,0,0,'OK');

#--------------------------------------------------------------------
if ($proto=~/imap/i) {

	my $imap = new Net::IMAP::Simple($host, timeout=>$timeout , ResvPort=>$port, use_ssl=>$use_ssl);

	if (!defined $imap) {
		$RC=1;
		$ev = "**ERROR** $Net::IMAP::Simple::errstr";
		print STDERR "$ev\n"; 
		$script->test_done('001',$lapse);
		$script->test_done('002',$num_msgs);
		$script->test_done('003',$RC);
		$script->print_metric_data();
		print "['003']['error'] $ev\n";
		exit 1;
	}

	my $r=$imap->login($user,$pwd);

	if (! defined $r) { 
		$RC=2;
		$ev = '**ERROR** '.$imap->errstr();
		print STDERR "$ev\n"; 
      $script->test_done('001',$lapse);
      $script->test_done('002',$num_msgs);
		$script->test_done('003',$RC);
      $script->print_metric_data();
		print "['003']['error'] $ev\n";
      exit 2;
	}

	$num_msgs=$imap->select($mailbox);
	if ($num_msgs eq '0E0') { $num_msgs=0; }
	if ($VERBOSE) { print "**imap_msgs=$num_msgs\n"; }

}
elsif ($proto=~/pop/i) {

   my $pop = new Mail::POP3Client( USER => $user, PASSWORD => $pwd, HOST => $host, PORT => $port, USESSL => $use_ssl);
   my $rc = $pop->Connect();
   if (! $rc) { 
		$RC=1;
		$ev = '**ERROR** '.$pop->Message();
		print STDERR "$ev\n";
      $script->test_done('001',$lapse);
      $script->test_done('002',$num_msgs);
		$script->test_done('003',$RC);
      $script->print_metric_data();
		print "['003']['error'] $ev\n";
      exit 1;
	}

	if ($VERBOSE) { 
		for( my $i = 1; $i <= $pop->Count(); $i++ ) {
  			foreach( $pop->Head( $i ) ) {
    			/^(From|Subject):\s+/i && print $_, "\n";
  			}
		}
	}

	$num_msgs=$pop->Count();
   $pop->Close();

}

my $t1=[gettimeofday];
my $elapsed = tv_interval ( $t0, $t1);
$lapse = sprintf("%.6f", $elapsed);

$script->test_done('001',$lapse);
$script->test_done('002',$num_msgs);
$script->test_done('003',$RC);
$script->print_metric_data();
print "['003']['error'] $ev\n";
exit 0;

