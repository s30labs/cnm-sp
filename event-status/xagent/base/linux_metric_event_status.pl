#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME:  linux_metric_event_status.pl
# AUTHOR: <fmarin\@s30labs.com>
# DATE: 26/05/2019
# VERSION: 1.0
#
# DESCRIPTION:
# Para los datos de la app especificada, mapea la ultima linea de datos recibida que coincide con un determinado pattern-group seg√n los patrones especificados en la estructura "mapper". Cada patron de "mapper" tiene asociado un valor numerico que sera el valor de la metrica. Estas reglas, se especifican en la seccion __DATA__ del script. Para utilizar otro mapeo de eventos, basta dupplicar el script y modificar la seccion __DATA__ del nuevo script.
#
# USAGE:
# linux_metric_event_status.pl -host x.x.x.x -app 33333300000x [-v]
# linux_metric_event_status.pl -h  : Help
#
# -host       : Host al que se asocia la metrica 
# -app        : ID de la app. 
# -v/-verbose : Verbose output (debug)
# -h/-help    : Help
#
# La configuracion de mapeo de eventos se incluye en el propio script en la seccion __DATA__
# OUTPUT:
# <001> Event Counter = 6
#
# </CNMDOCU>
#--------------------------------------------------------------------
MYHEADER
};
use lib '/opt/crawler/bin/';
use strict;
use warnings;
use Getopt::Long;
use CNMScripts::Events;
use Data::Dumper;
use JSON;
use Encode qw(encode_utf8);

#--------------------------------------------------------------------
#--------------------------------------------------------------------
my $script = CNMScripts::Events->new();
my %opts = ();
my $ok=GetOptions (\%opts,'h','help','v','verbose','app=s','lapse=s','pattern=s','host=s', 'json' );
if (! $ok) {
	print STDERR "***ERROR EN EL PASO DE PARAMETROS***\n";	
	$script->usage($main::MYHEADER); 
	exit 1;
}

my $VERBOSE = ((defined $opts{'v'}) || (defined $opts{'verbose'})) ? 1 : 0;

if ( ($opts{'h'}) || ($opts{'help'})) { $script->usage($main::MYHEADER); }

if ($VERBOSE) {
   print "PARAMETERS *****\n";
   print Dumper (\%opts);
   print "*****\n";
}

#--------------------------------------------------------------------
my $STATUS_MAP = get_script_config();
if ($VERBOSE) { print Dumper ($STATUS_MAP),"\n"; }
my $PATTERN = $STATUS_MAP->{'pattern_group'};
#--------------------------------------------------------------------
my $dbh = $script->dbConnect();
my ($status_now, $info, $last_ts)  = $script->get_last_status_event($dbh, {'id_app'=>$opts{'app'}, 'pattern'=>$PATTERN}, $STATUS_MAP->{'mapper'});
if ($script->err_num() != 0) { print STDERR $script->err_str(),"***\n"; }
$script->dbDisconnect($dbh);

my @items = ();
foreach my $h (@{$STATUS_MAP->{'mapper'}}) {
	push @items,$h->{'name'};
}
my $items_txt = join (' | ', @items);
#--------------------------------------------------------------------
#--------------------------------------------------------------------
%CNMScripts::RESULTS=();
my $last_ts_lapse = ($last_ts eq 'U') ? 0 : int((time()-$last_ts)/60);
$script->test_init('001', $items_txt);
$script->test_init('002', "Last ts (seg)");
$script->test_init('003', "Last ts lapse (min)");
$script->test_done('001',$status_now);
$script->test_done('002',$last_ts);
$script->test_done('003',$last_ts_lapse);
$script->print_metric_data();

if ($info ne 'UNK') {

	#Se escapan comillas en los valores del vector json
	my $json = JSON->new();
	my $info1 = encode_utf8($info);
	my $vinfo = validate_json($info1);
#$vinfo = $info;
	my $event_info = {};
	eval {
		$event_info = decode_json($vinfo);
	};
	if (! $@) {
		if (exists $event_info->{'extrafile2'}) { 
			print "[001][extrafile2]$event_info->{'extrafile2'}\n";
		}
      elsif (exists $event_info->{'0extrafile2'}) {
         print "[001][0extrafile2]$event_info->{'0extrafile2'}\n";
      }
	}
	#else { print "**ERROR** ($@)\n"; print "$vinfo\n"; }
	#print Dumper($event_info);
}
exit 0;

#--------------------------------------------------------------------
# validate_json
# Simple validation of JSON hash. Escapes double quotes in hash value
#--------------------------------------------------------------------
sub validate_json {
my ($json)=@_;

	$json =~ s/^\{(.+)\}$/$1/;
	my @parts = split (/"\s*,\s*"/, $json );
	my @new_parts = ();
	foreach my $p (@parts) {
   	my ($k,$v) = split (/"\s*:\s*"/, $p );
		$k=~s/^\"(.+)\"$/$1/;
		$k=~s/"/\\"/g;
#print "**$k | ";
      $v=~s/^\"(.+)\"$/$1/;
      $v=~s/"/\\"/g;
#print "$v**\n";
      push @new_parts, "\"$k\":\"$v\"";
   }
   return '{'.join(',',@new_parts).'}';
}

#--------------------------------------------------------------------
sub get_script_config {

   local($/) = undef;
	my $txt = <DATA>;
	my $json = JSON->new();
	my $cfg = $json->decode($txt);
   return $cfg;
}

1;

__DATA__
{"pattern_group":"\"Subject\":\"SAMPLE - JOB","mapper":[{"name":"JOB Started (1)", "pattern":"\"Subject\":\"SAMPLE - JOB Started : application ABC\"", "value":"1"}, {"name":"JOB Ended (0)", "pattern":"\"Subject\":\"SAMPLE - JOB Ended : application ABC\"", "value":"0"}]}
