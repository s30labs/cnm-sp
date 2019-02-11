#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME:  linux_metric_event_data.pl
# AUTHOR: <fmarin\@s30labs.com>
# DATE: 26/03/2018
# VERSION: 1.0
#
# DESCRIPTION:
# Cuenta los eventos recibidos en la tabla logp_xxx especificada en app durante el intervalo especificado en lapse (now-lapse) y que cumplen con  el patron especificado en pattern. 
# Si no se especifica pattern, se cuentan todos los eventos.
# Lapse se indica en minutos. Por defecto son 60 min.
#
# USAGE:
# linux_metric_event_data.pl -app 333333000006 -lapse 1440 -pattern '"CNM_Flag":"01"' -field total [-v]
# linux_metric_event_data.pl -app 333333000006 -lapse 1440 -pattern '"CNM_Flag":"01"' -field total|max [-v]
# linux_metric_event_data.pl -h  : Help
#
# -host       : Host al que se asocia la metrica 
# -app        : ID de la app. 
# -syslog     : IP del equipo que envia por syslog. 
# -trap       : IP|id_dev|name.domain del equipo que envia el trap. 
# -lapse      : Intervalo seleccionado referenciado desde el instante actual (now-lapse). Se especifica en minutos. Por defecto 60.
# -pattern    : Patron de busqueda. Por defecto se cuentan todos los eventos.
# -field      : Campo/s JSON del evento que contiene el dato solicitado. Se pueden especificar varios, separados por "|".
# -oper       : value | sum ...
# -v/-verbose : Verbose output (debug)
# -h/-help    : Help
#
# OUTPUT:
# <001.field_name> Field Data = 6
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

#--------------------------------------------------------------------
#--------------------------------------------------------------------
my $script = CNMScripts::Events->new();
my %opts = ();
my $ok=GetOptions (\%opts,  'h','help','v','verbose','app=s','lapse=s','pattern=s','host=s', 'field=s', 'json', 'oper=s' );
if (! $ok) {
	print STDERR "***ERROR EN EL PASO DE PARAMETROS***\n";	
	$script->usage($main::MYHEADER); 
	exit 1;
}

my $VERBOSE = ((defined $opts{'v'}) || (defined $opts{'verbose'})) ? 1 : 0;

if ( ($opts{'h'}) || ($opts{'help'})) { $script->usage($main::MYHEADER); }

my $FIELD = (defined $opts{'field'}) ? $opts{'field'} : '';   # SELECT ALL

my $LAPSE = (defined $opts{'lapse'}) ? $opts{'lapse'} : 60;				# 60 minutes

my $PATTERN = (defined $opts{'pattern'}) ? $opts{'pattern'} : '';   # SELECT ALL

my $OPER = (defined $opts{'oper'}) ? $opts{'oper'} : 'value';   # value|sum ...

if ($VERBOSE) {
   print "PARAMETERS *****\n";
   print Dumper (\%opts);
   print "*****\n";
}

#--------------------------------------------------------------------
my $dbh = $script->dbConnect();

my ($values, $info, $last_ts, $last_ts_lapse) = ({},'UNK','U',0);
if ($opts{'app'}) {

	if ($OPER eq 'sum') {
		($values, $info, $last_ts)  = $script->get_application_data_sum($dbh, {'id_app'=>$opts{'app'}, 'pattern'=>$PATTERN, 'lapse'=>$LAPSE, 'field'=>$FIELD});
	}
	else {
		($values, $info, $last_ts)  = $script->get_application_data($dbh, {'id_app'=>$opts{'app'}, 'pattern'=>$PATTERN, 'lapse'=>$LAPSE, 'field'=>$FIELD});
	}

	if ($script->err_num() != 0) { print STDERR $script->err_str(),"***\n"; }

}
elsif ($opts{'trap'}) {  

}
elsif ($opts{'syslog'}) { 

}
else { $script->usage($main::MYHEADER); }


$script->dbDisconnect($dbh);
#--------------------------------------------------------------------
#--------------------------------------------------------------------
%CNMScripts::RESULTS=();
$last_ts_lapse = ($last_ts eq 'U') ? 0 : int((time()-$last_ts)/60);
#$script->test_init('001', "Field Data");
$script->test_init('002', "Last ts (seg)");
$script->test_init('003', "Last ts lapse (min)");
foreach my $k (sort keys %$values) {
	my $ktxt = '001.'.$k;
	my $kinfo = 'Field Data ('.$k.')';
	my $kval = $values->{$k};
	$script->test_init($ktxt, $kinfo);
	$script->test_done($ktxt,$kval);
}
$script->test_done('002',$last_ts);
$script->test_done('003',$last_ts_lapse);
$script->print_metric_data();

if ($info ne 'UNK') {

	#Se escapan comillas en los valores del vector json
	my $vinfo = validate_json($info);
#$vinfo = $info;
	my $event_info = {};
	eval {
		$event_info = decode_json($vinfo);
	};
	if (! $@) {
		if (exists $event_info->{'extrafile2'}) { 
			print "[001][extrafile2]$event_info->{'extrafile2'}\n";
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
		if (! defined $v) { $v=''; }
		$k=~s/^\"(.+)\"$/$1/;
		$k=~s/"/\\"/g;
#print "**$k | ";
      $v=~s/^\"(.+)\"$/$1/;
      $v=~s/"/\\"/g;
#print "$v**\n";
      push @new_parts, "\"$k\":\"$v\"";
   }
   return '{'.join(',',@new_parts).'}';

#{"DAYVALIDATIONDATE":"\\"20180606\\""
#,
#"MANDT":"\\"800\\""
#,
#
#   	$k=~s/^\{"(.+)$/$1/;
#   	$v=~s/^(.+)"\}$/$1/;
#   	$v=~s/"/\\"/g;
#	   #print "$k  :  $v\n";
#   	push @new_parts, "\"$k\":\"$v\"";
#	}
#	return '{'.join(',',@new_parts).'}';

}

