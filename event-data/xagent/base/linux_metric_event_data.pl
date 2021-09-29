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
# -lapse      : Intervalo seleccionado referenciado desde el instante actual (now-lapse). Se especifica en minutos. Por defecto 60. Si el valor es today, internamente calcula la diferencia desde las 00.00 hasta now.
# -pattern    : Patron de busqueda. Por defecto se cuentan todos los eventos.
# -field      : Campo/s JSON del evento que contiene el dato solicitado. Se pueden especificar varios, separados por "|".
# -oper       : value | sum (Para calcular el estado del dispositivo deben ser value_mant | sum_mant)
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
use CNMScripts::CNMAPI;
use Time::Local;
use Data::Dumper;
use JSON;

#--------------------------------------------------------------------
my $LOG_LEVEL = 'info';

#--------------------------------------------------------------------
my $script = CNMScripts::Events->new('log_level' => $LOG_LEVEL);
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
my $device_status = 0; # 0:active | 1:inactive | 2:maintenance
if (($OPER=~/mant/) && (defined $opts{'host'})) { $device_status = get_device_status($opts{'host'}); }

#--------------------------------------------------------------------
my $ts=time();
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($ts);
if ($LAPSE eq 'today') { 
	$LAPSE = int(($ts - timelocal(0, 0, 0, $mday, $mon, $year))/60); 
	if ($VERBOSE) { print "LAPSE=today >>> $LAPSE\n"; }
}

#--------------------------------------------------------------------
my $dbh = $script->dbConnect();

my ($values, $info, $last_ts, $last_ts_lapse) = ({},'UNK','U',0);
if ($opts{'app'}) {

	($values, $info, $last_ts)  = $script->get_application_data_ext($dbh, {'id_app'=>$opts{'app'}, 'pattern'=>$PATTERN, 'lapse'=>$LAPSE, 'field'=>$FIELD, 'oper'=>$OPER});

#	if ($OPER eq 'sum') {
#		($values, $info, $last_ts)  = $script->get_application_data_ext($dbh, {'id_app'=>$opts{'app'}, 'pattern'=>$PATTERN, 'lapse'=>$LAPSE, 'field'=>$FIELD, 'oper'=>$OPER});
#	}
#	else {
#		($values, $info, $last_ts)  = $script->get_application_data($dbh, {'id_app'=>$opts{'app'}, 'pattern'=>$PATTERN, 'lapse'=>$LAPSE, 'field'=>$FIELD});
#	}

	if ($script->err_num() != 0) { print STDERR $script->err_str(),"***\n"; }

}
elsif ($opts{'trap'}) {  

}
elsif ($opts{'syslog'}) { 

}
else { $script->usage($main::MYHEADER); }


$script->dbDisconnect($dbh);

#--------------------------------------------------------------------
my $stored=[];
if (exists $ENV{'CNM_TAG_RRD_FILE'}) {
	if (-f $ENV{'CNM_TAG_RRD_FILE'}) {
   	$stored=$script->fetch_avg_rrd($ENV{'CNM_TAG_RRD_FILE'},'30d');
	}
	else {
		foreach my $k (keys %$values) { push @$stored, '0'; }
	}
   if ($VERBOSE) { print Dumper($stored); }
}


#--------------------------------------------------------------------
#--------------------------------------------------------------------
%CNMScripts::RESULTS=();
$last_ts_lapse = ($last_ts eq 'U') ? 0 : int((time()-$last_ts)/60);
#$script->test_init('001', "Field Data");
#$script->test_init('101', "Field Data Stored");
$script->test_init('002', "Last ts (seg)");
$script->test_init('003', "Last ts lapse (min)");
foreach my $k (sort keys %$values) {
	my $ktxt = '001.'.$k;
	my $kinfo = 'Field Data ('.$k.')';
	my $kval = $values->{$k};
	$script->test_init($ktxt, $kinfo);
	$script->test_done($ktxt,$kval);
}

my $i=-1;
foreach my $k (sort keys %$values) {
	$i+=1;
   my $ktxt = '001.30d.'.$k;
   my $kinfo = 'Field Data Stored ('.$k.')';
	if (!exists $stored->[$i]) { next; }
   my $kval = $stored->[$i];
   $script->test_init($ktxt, $kinfo);
   $script->test_done($ktxt,$kval);
}

$script->test_done('002',$last_ts);
$script->test_done('003',$last_ts_lapse);

if ($OPER=~/mant/) {
	$script->test_init('004', "Device Status");
	$script->test_done('004',$device_status);

	foreach my $k (sort keys %$values) {
   	my $ktxt = '005.'.$k;
   	my $kinfo = 'Field Data with device status ('.$k.')';
   	my $kval = $values->{$k};

   	# Si se ha especificado oper con "mant" se ha calculado antes $device_status
   	# Si es > 0 ==> inactivo o mantenimiento. En ambos casos se suma 10 para contemplarlo
   	if ($device_status>0) { $kval+=10; }

   	$script->test_init($ktxt, $kinfo);
   	$script->test_done($ktxt,$kval);
	}
}

$script->print_metric_data();

if ($VERBOSE) { print "--INFO--\n"; print Dumper($info); }

if ($info ne 'UNK') {

	#Se escapan comillas en los valores del vector json
	my $vinfo = validate_json($info);
	if ($VERBOSE) { print "--INFO--\n"; print Dumper($vinfo); }
#$vinfo = $info;
	my $event_info = {};
	eval {
		$event_info = decode_json($vinfo);
	};
	if (! $@) {
		if ($VERBOSE) { print "--EVENT_INFO--\n"; print Dumper($event_info); }
		my @subtags = sort keys %$values;
		if ($VERBOSE) { print Dumper(\@subtags); }

		my $tag = $subtags[0];
		if (exists $event_info->{'extrafile2'}) { 
			print "[001.$tag][extrafile2]$event_info->{'extrafile2'}\n";
		}
      elsif (exists $event_info->{'0extrafile2'}) {
         print "[001.$tag][0extrafile2]$event_info->{'0extrafile2'}\n";
      }
      elsif (exists $event_info->{'image'}) {
         print "[001.$tag][image]$event_info->{'image'}\n";
      }
      elsif (exists $event_info->{'image_ok'}) {
         print "[001.$tag][image_ok]$event_info->{'image_ok'}\n";
      }
	}
	else { 
		if ($VERBOSE) { print "**ERROR** ($@)\n"; print "$vinfo\n"; }
	}
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
   	my ($k,$v) = split (/"\s*:\s*/, $p );

if ($VERBOSE) { print "p=$p >> k=$k---v=$v\n"; }

		if (! defined $v) { $v=''; }
		#$k=~s/^\"(.+)\"$/$1/;
		$k=~s/^\"(.+)$/$1/;
		$k=~s/(.+)\"$/$1/;
		$k=~s/"/\\"/g;
#print "**$k | ";
      #$v=~s/^\"(.+)\"$/$1/;
      $v=~s/^\"(.+)$/$1/;
		$v=~s/(.+)\"$/$1/;
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

#--------------------------------------------------------------------
# status = 0 (active) | 1 (removed) | 2 (maintenance)
sub get_device_status {
my ($ip) = @_;

   my $host_ip = 'localhost';
   my $log_level = 'info';

   my $api=CNMScripts::CNMAPI->new( 'host'=>$host_ip, 'timeout'=>10, 'log_level'=>$log_level );
   my ($user,$pwd)=('admin','cnm123');
   my $sid = $api->ws_get_token($user,$pwd);
   if ($VERBOSE) { print "sid=$sid\n"; }

   my $class='devices';
   my $endpoint=$ip.'.json';

   my $response = $api->ws_get($class,$endpoint);

   my ($STATUS,$RC)=(0,0);
   if ($api->err_num() != 0) {
      $STATUS = 3;
      $RC=$api->err_num();
      print STDERR '**ERROR** ($RC) >>'.$api->err_str()."\n";
   }
   else {
      $STATUS = $response->[0]->{'status'};
   }
   if ($VERBOSE) { print Dumper($response); }

   return $STATUS;
}


