#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME:  linux_metric_event_window.pl
# AUTHOR: <fmarin\@s30labs.com>
# DATE: 26/03/2018
# VERSION: 1.0
#
# DESCRIPTION:
# Monitor event reception inside a temporal window specified by parameters.
# The event is defined using a pattern and a time lapse for the app ID query.
#
# USAGE:
# linux_metric_event_window.pl  -host 1.1.1.16 -app 333333001056 -wt 8,15,19 -ws 60 -pattern "dir|eqs|store/archives" -lapse 60
# linux_metric_event_window.pl -h  : Help
#
# -host       : Host for metric association.
# -app        : APP Id.
# -wt         : Window Time for positioning the center of the window. (several values specified by comma)
#               Valid formats are: "8" "8,15" "8:30,15:30"
# -ws         : Window size (in minutes). Default is 60.
# -lapse      : APP ID table querying lapse from current time. (minutes)
# -pattern    : APP ID table querying pattern.
# -v/-verbose : Verbose output (debug)
# -h/-help    : Help
#
# OUTPUT:
# <001> Monitoring Window = 0
# <002> Error Window = 0
# <003> Number of Files = U
# <004> Received Status Time Lapse (min) = 0
# <005> Wait Status Time Lapse (min) = 0
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
use Time::Local;

#--------------------------------------------------------------------
#my $LOG_LEVEL = 'debug';
#my $LOG_MODE = 3;
my $LOG_LEVEL = 'info';
my $LOG_MODE = 1;

#--------------------------------------------------------------------
my $script = CNMScripts::Events->new('log_level' => $LOG_LEVEL, 'log_mode' => $LOG_MODE);
my %opts = ();
my $ok=GetOptions (\%opts,  'h','help','v','verbose','app=s','lapse=s','pattern=s','host=s', 'json', 'current_date=s', 'wt=s', 'ws=s');
if (! $ok) {
	print STDERR "***ERROR EN EL PASO DE PARAMETROS***\n";	
	$script->usage($main::MYHEADER); 
	exit 1;
}

my $VERBOSE = ((defined $opts{'v'}) || (defined $opts{'verbose'})) ? 1 : 0;

if ( ($opts{'h'}) || ($opts{'help'})) { $script->usage($main::MYHEADER); }

if (!$opts{'app'}) { $script->usage($main::MYHEADER); }
if (!$opts{'wt'}) { $script->usage($main::MYHEADER); }

my $WINDOW_SIZE = (defined $opts{'ws'}) ? $opts{'ws'} : 60;

my ($in_window,$in_error_window,$waiting_lapse) = window_manager($opts{'wt'},$WINDOW_SIZE);
if ($VERBOSE) { print "in_window=$in_window\n"; }


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
my ($value, $info, $last_ts, $last_ts_lapse) = (0,'UNK','U',0);

if ($in_window) {
	my $dbh = $script->dbConnect();
	($value, $info, $last_ts)  = $script->get_application_events_json($dbh, {'id_app'=>$opts{'app'}, 'pattern'=>$param_pattern, 'lapse'=>$LAPSE, 'operator'=>$OPERATOR });
	$script->dbDisconnect($dbh);
}

# Si hay ficheros, no se presenta la ventana de error
if ($value>0) { $in_error_window = 0; }

$last_ts_lapse = ($last_ts eq 'U') ? 0 : int((time()-$last_ts)/60);
$script->test_init('001', "Monitoring Window");
$script->test_init('002', "Error Window");
$script->test_init('003', "Number of Files");
$script->test_init('004', "Received Status Time Lapse (min)");
$script->test_init('005', "Wait Status Time Lapse (min)");
$script->test_done('001',$in_window);
$script->test_done('002',$in_error_window);
$script->test_done('003',$value);
$script->test_done('004',$last_ts_lapse);
$script->test_done('005',$waiting_lapse);
$script->print_metric_data();

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
# window_manager
# spec --> 	contiene la especificacion de la ventana de chequeo. 
#				Son valores que aplican al dia. Separados por ','
#				Ej: 8,15,22
# window_size -> Contains the window size in minutes
#--------------------------------------------------------------------
sub window_manager {
my ($spec,$window_size)=@_;

	my @w = split(',',$spec);
	$window_size *= 60;

	my $ts_now=time;
   my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($ts_now);
	#$year += 1900;
   #$mon += 1;
   #my $file_date = sprintf("%04d%02d%02d-%02d:%02d:%02d",$year,$mon,$mday,$hour,$min,$sec);

	my $in_window = 0;
	my $in_error_window = 0;
	my $waiting_lapse = 0;
	foreach my $spec_hour_min (@w) {

		#spec_hour puede ser del tipo 8,15,20 o 8:30,15:20,20:35
		my $spec_min=0;
		my $spec_hour = $spec_hour_min;
		if ($spec_hour_min=~/^(\d+)\:(\d+)$/) { $spec_hour=$1; $spec_min=$2; }

		my $ts_from_window = timelocal( 0, $spec_min, $spec_hour, $mday, $mon, $year );
		$ts_from_window -= $window_size/2;

		my $tdiff = $ts_now-$ts_from_window;
		if ($VERBOSE) { print "spec_hour_min=$spec_hour:$spec_min >> $ts_now - $ts_from_window  ($tdiff) < $window_size\n"; }
		if ($tdiff < 0) { next; }
	
		if ($ts_now-$ts_from_window < $window_size) {
			$in_window = 1;
			$in_error_window = 0;
			$waiting_lapse = int($tdiff/60); 
			last;
		} 
		elsif ($ts_now-$ts_from_window < 1.5*$window_size) {
         $in_window = 1;
         $in_error_window = 1;
         $waiting_lapse = int($tdiff/60);
         last;
      }
	}

	if ($waiting_lapse<0) { $waiting_lapse=0; }
	return ($in_window,$in_error_window,$waiting_lapse);

}


