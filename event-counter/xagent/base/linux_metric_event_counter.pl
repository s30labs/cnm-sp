#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME:  linux_metric_event_counter.pl
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
# linux_metric_event_counter.pl -app 333333000006 -lapse 120 -pattern '"MDW_Alert_Type":"MAT"' [-v]
# linux_metric_event_counter.pl -app 333333000006 -lapse 120 -pattern 'MDW_Alert_Type|eq|MAT' -json [-v]
# linux_metric_event_counter.pl -app 333333000006 -lapse 120 -pattern 'TRANSCOLA|gt|10&AND&MDW_Alert_Type|eq|MAT' -json [-v]
# linux_metric_event_counter.pl -syslog ip -lapse 120 -pattern 'FTP.Login.Failed' [-v]
# linux_metric_event_counter.pl -trap ip|id_dev|name.domain -lapse 120 -pattern 'FTP.Login.Failed' [-v]
# linux_metric_event_counter.pl -h  : Help
#
# -host       : Host al que se asocia la metrica 
# -app        : ID de la app. 
# -syslog     : IP del equipo que envia por syslog. 
# -trap       : IP|id_dev|name.domain del equipo que envia el trap. 
# -lapse      : Intervalo seleccionado referenciado desde el instante actual (now-lapse). Se especifica en minutos. Por defecto 60.
# -pattern    : Patron de busqueda. Por defecto se cuentan todos los eventos.
# -json       : Decodifica la linea en JSON. Permite condiciones mas complejas. 
#               En este caso pattern puede ser una lista de condiciones separadas por &AND& o &OR&
#               Cada condicion es del tipo: TRANSCOLA|gt|10 o ERRORMSG|eq|"" -> key|operador|value
#               Los operadores soportados son: gt, gte, lt, lte, eq, ne
# -v/-verbose : Verbose output (debug)
# -h/-help    : Help
#
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
my $LOG_LEVEL = 'info';
#--------------------------------------------------------------------
my $script = CNMScripts::Events->new('log_level' => $LOG_LEVEL);
my %opts = ();
my $ok=GetOptions (\%opts,  'h','help','v','verbose','app=s','lapse=s','pattern=s','host=s', 'json', 'current_date=s');
if (! $ok) {
	print STDERR "***ERROR EN EL PASO DE PARAMETROS***\n";	
	$script->usage($main::MYHEADER); 
	exit 1;
}

my $VERBOSE = ((defined $opts{'v'}) || (defined $opts{'verbose'})) ? 1 : 0;

if ( ($opts{'h'}) || ($opts{'help'})) { $script->usage($main::MYHEADER); }

if ((!$opts{'app'}) && (!$opts{'trap'}) && (!$opts{'syslog'})) { $script->usage($main::MYHEADER); }

my $LAPSE = (defined $opts{'lapse'}) ? $opts{'lapse'} : 60;				# 60 minutes
if ($LAPSE =~ /newest-(\d+)/) {
	$script->newest(1);
	$LAPSE=$1;
}

my $param_pattern = (defined $opts{'pattern'}) ? $opts{'pattern'} : '';   # SELECT ALL

#[op:<>]"SUBCLASS":"%Level"
my $OPERATOR = '';

if ($VERBOSE) {
   print "PARAMETERS *****\n";
   print Dumper (\%opts);
   print "*****\n";
}

#--------------------------------------------------------------------
my $dbh = $script->dbConnect();

#--------------------------------------------------------------------
# PATTERN variables and operators evaluation
#--------------------------------------------------------------------
# 1 solo pattern:
#CNM_APP|eqs|Asset Center
# 2 patterns modo standar ==> 2 items ==> Separados por []
#APP|eqs|TJ_ASS_Import_CDPF_AND_STATUS|eqs|TERMINE[]APP|eqs|TJ_ASS_Import_CDPF_AND_STATUS|eqs|NON-PLANIFIE[]
# 2 patterns modo short (para acortar la longitud del parametro) ==> El comun al principio [_AND_xxxx] o [_OR_ xxxx]
#[_AND_APP|eqs|TJ_ETP_A7_ExpToEasyvista]STATUS|eqs|TERMINE[]STATUS|eqs|EN-ERREUR

my $GLOBAL_OP = '';
my @PATTERNS = split (/\[\]/, $param_pattern);
#Chequeo modo short
#if (($param_pattern =~ /^\[(_AND_.+?)\](.+)$/) || ($param_pattern =~ /^(\[_OR_.+\])(.+)$/)) {
if (($param_pattern =~ /^\[(.+?_AND_)\](.+)$/) || ($param_pattern =~ /^\[(.+?_OR_)\](.+)$/)) {
	if ($VERBOSE) { print "NO GLOBAL_OP=$GLOBAL_OP---\n"; }
	my $param_all = $1;
	my $param_short = $2;
	my @vp = split (/\[\]/, $param_short);
	@PATTERNS = ();
	foreach my $p (@vp) { push @PATTERNS, $param_all.$p; }
}
elsif (($param_pattern =~ /^\((\S+?)\)\[(.+?_AND_)\](.+)$/) || ($param_pattern =~ /^\[(\S+?)\]\[(.+?_OR_)\](.+)$/)) {
   $GLOBAL_OP = $1;
	if ($VERBOSE) { print "GLOBAL_OP=$GLOBAL_OP---\n"; }
   my $param_all = $2;
   my $param_short = $3;
   my @vp = split (/\[\]/, $param_short);
   @PATTERNS = ();
   foreach my $p (@vp) { push @PATTERNS, $param_all.$p; }
}

if ($VERBOSE) { print Dumper(\@PATTERNS); }

if ($param_pattern eq '') { @PATTERNS = (''); }
my $MULTI_PATTERNS = scalar(@PATTERNS);
if ($VERBOSE) { print "MULTI_PATTERNS=$MULTI_PATTERNS\n"; }

my ($value, $info, $last_ts, $last_ts_lapse) = ('U','UNK','U',0);
my @avalue=();
my @ainfo=();
my @alast_ts=();
foreach my $PATTERN (@PATTERNS) {
	
	$PATTERN = $script->eval_current_date(\%opts,$PATTERN);
	($PATTERN,$OPERATOR) = $script->eval_operator($PATTERN);

	if ($VERBOSE) {
		print "PATTERN=$PATTERN\tOPERATOR=$OPERATOR\n";
	}

	#--------------------------------------------------------------------
	($value, $info, $last_ts, $last_ts_lapse) = ('U','UNK','U',0);
	if ($opts{'app'}) {
	
		if (defined $opts{'json'}) {
			($value, $info, $last_ts)  = $script->get_application_events_json($dbh, {'id_app'=>$opts{'app'}, 'pattern'=>$PATTERN, 'lapse'=>$LAPSE, 'operator'=>$OPERATOR });
		}
		else {
			($value, $info, $last_ts)  = $script->get_application_events($dbh, {'id_app'=>$opts{'app'}, 'pattern'=>$PATTERN, 'lapse'=>$LAPSE, 'operator'=>$OPERATOR });
		}
		if ($script->err_num() != 0) { print STDERR $script->err_str(),"***\n"; }

		push @avalue, $value;
		push @ainfo, $info;
		push @alast_ts, $last_ts;

	}
	elsif ($opts{'trap'}) {  

	}
	elsif ($opts{'syslog'}) { 

	}

}

$script->dbDisconnect($dbh);
#--------------------------------------------------------------------
if ($GLOBAL_OP eq '_MAXTS_'){
	my $max_idx = $script->max_index(\@alast_ts);
	if ($VERBOSE) { print "GLOBAL_OP=$GLOBAL_OP >> max_idx=$max_idx >> @alast_ts";}
	for my $i (0..$MULTI_PATTERNS-1) {
		if ($i == $max_idx) { next;}
		$alast_ts[$i] = 'U';
	}
}
#--------------------------------------------------------------------
%CNMScripts::RESULTS=();

if ($MULTI_PATTERNS>1) {
	for my $i (0..$MULTI_PATTERNS-1) {	
		my $iid = sprintf "%03d", $i+1;
		$last_ts_lapse = ($alast_ts[$i] eq 'U') ? 0 : int((time()-$alast_ts[$i])/60);
	   $script->test_init("001.$iid", "Event Counter");
   	$script->test_init("002.$iid", "Last ts (seg)");
   	$script->test_init("003.$iid", "Last ts lapse (min)");
   	$script->test_done("001.$iid",$avalue[$i]);
   	$script->test_done("002.$iid",$alast_ts[$i]);
   	$script->test_done("003.$iid",$last_ts_lapse);
	}
	$script->print_metric_data();
}
else {
	$last_ts_lapse = ($last_ts eq 'U') ? 0 : int((time()-$last_ts)/60);
	$script->test_init('001', "Event Counter");
	$script->test_init('002', "Last ts (seg)");
	$script->test_init('003', "Last ts lapse (min)");
	$script->test_done('001',$value);
	$script->test_done('002',$last_ts);
	$script->test_done('003',$last_ts_lapse);
	$script->print_metric_data();
}

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

