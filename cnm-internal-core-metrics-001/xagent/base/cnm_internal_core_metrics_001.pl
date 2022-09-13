#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME:  cnm_metric_core_metrics.pl
# AUTHOR: <fmarin\@s30labs.com>
# DATE: 26/03/2018
# VERSION: 1.0
#
# DESCRIPTION:
# Obtiene metricas de estado sobre la recepcion de correos por IMAP4 cada periodo de polling especificado (def. 5 minutos).
#
# USAGE:
# cnm_metric_core_metrics.pl -host xxxx -lapse 300
# cnm_metric_core_metrics.pl -h  : Help
#
# -lapse      : Intervalo seleccionado referenciado desde el instante actual (now-lapse) para parsing del log
# -v/-verbose : Verbose output (debug)
# -h/-help    : Help
#
# OUTPUT:
# <001> Num of mails in IMAP4 inbox = 7
# <002> Access status to IMAP4 inbox = 0
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
use JSON;
use Encode qw(encode_utf8);
use Time::Local;

#--------------------------------------------------------------------
#my $LOG_LEVEL = 'debug';
#my $LOG_MODE = 3;
my $LOG_LEVEL = 'info';
my $LOG_MODE = 1;
my $FILE_LOG = '/var/log/crawler_debug.log';
my $LOG_PATTERN = 'core-imap4:: IMAP CONEX OK |core-imap4:: \*\*ERROR\*\*';

#--------------------------------------------------------------------
my $script = CNMScripts->new('log_level' => $LOG_LEVEL, 'log_mode' => $LOG_MODE);
my %opts = ();
my $ok=GetOptions (\%opts,  'h','help','v','verbose','host=s','lapse=s');
if (! $ok) {
	print STDERR "***ERROR EN EL PASO DE PARAMETROS***\n";	
	$script->usage($main::MYHEADER); 
	exit 1;
}

my $VERBOSE = ((defined $opts{'v'}) || (defined $opts{'verbose'})) ? 1 : 0;

if ( ($opts{'h'}) || ($opts{'help'})) { $script->usage($main::MYHEADER); }


my $lapse = (defined $opts{'lapse'}) ? $opts{'lapse'} : 60;				# 60 minutes

if ($VERBOSE) {
   print "PARAMETERS *****\n";
   print Dumper (\%opts);
   print "*****\n";
}

my $p = $script->grep_patterns($lapse);
if ($VERBOSE) { print Dumper ($p); }

my $date_pattern = join ('|', @$p);
my $cmd = "/bin/egrep '$date_pattern' $FILE_LOG | /bin/egrep '$LOG_PATTERN'";
if ($VERBOSE) { print "cmd=$cmd\n"; }

my @V = `$cmd`;
if ($VERBOSE) { print Dumper(\@V); }

my ($imap_nmsgs,$imap_error)=(0,0);
foreach my $l (@V) {
	chomp $l;
	if ($l=~/core-imap4\:\:/) {
		if ($l=~/CONEX OK (\w+) MSGs in INBOX/) {
			$imap_nmsgs=$1;
			if ($imap_nmsgs eq '0E0') { $imap_nmsgs=0; }
		}
		elsif ($l=~/\*\*ERROR\*\* EN CONEXION IMAP/) { $imap_error = 2; }
		elsif ($l=~/\*\*ERROR\*\* EN LOGIN IMAP/) { $imap_error = 1; }
		elsif ($l=~/\*\*ERROR\*\* SIN FICHERO DE CONFIGURACION/) { $imap_error = 4; }
		elsif ($l=~/\*\*ERROR\*\* SIN CREDENCIALES DE ACCESO/) { $imap_error = 3; }
	}
}

#--------------------------------------------------------------------

$script->test_init('001', "Num of mails in IMAP4 inbox");
$script->test_init('002', "Access status to IMAP4 inbox");
$script->test_done('001',$imap_nmsgs);
$script->test_done('002',$imap_error);
$script->print_metric_data();

exit 0;


#--------------------------------------------------------------------
# grep_patterns
# Crea las cadenas necesarias para parsear el log lapse secs, desde el instante actual
# Si tnow = Jul 14 20:26:10 y lapse=300 seran:
# Jul 14 20:21|Jul 14 20:22|Jul 14 20:23|Jul 14 20:24|Jul 14 20:25|Jul 14 20:26 
#--------------------------------------------------------------------
sub grep_patterns {
my ($lapse)=@_;

#	my $nmin=1;
#	if ($lapse==60) { $nmin=1; }
#	elsif ($lapse==300) { $nmin=6; }
#	else { $nmin = int $lapse/60; }

	my $nmin = int($lapse/60) + 1;

	my @patterns = ();
	my @month = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
	my $ts_now = time;
	my $tx = $ts_now - $nmin*60;

	while ($nmin>=0) {		
	   my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($tx);
   	my $px = sprintf("%s %02d %02d:%02d",$month[$mon],$mday,$hour,$min);
		$tx += 60;
		$nmin-=1;

		push @patterns,$px;
		if ($VERBOSE) { print "$px ($tx)\n"; }
	}

	return \@patterns;

}


