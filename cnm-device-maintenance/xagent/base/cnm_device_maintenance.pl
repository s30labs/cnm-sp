#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME: cnm-device-maintenance.pl
# AUTHOR: Fernando Marin <fmarin\@s30labs.com>
# DATE: 07/07/2020
# VERSION: 1.0
#
# DESCRIPTION:
# Each device can store a JSON calendar file in a custom field in order to specify complex maintenance periods.
# This script check this files and set each device in its propper state.
#
# USAGE:
# cnm-device-maintenance.pl
# cnm-device-maintenance.pl [-log-level info|debug] [-log-mode 1|2|3] [-dir-base /store/www-user/calendar] [-custom-field CNM-MAINTENANCE] [-v]
# cnm-device-maintenance.pl -dir-base /cfg/1234 -custom-field my_custom_field
# cnm-device-maintenance.pl -help
#
# -help : Help
# -v    : Verbose mode
# -log-level : info|debug
# -log-mode : 1 => syslog | 2 => stdout | 3 => both
# -dir-base : /store/www-user/calendar (default)
# -custom-field : CNM-MAINTENANCE (default)
#
# </CNMDOCU>
#--------------------------------------------------------------------
MYHEADER
};
use lib "/opt/crawler/bin", "/opt/crawler/bin/support";
use strict;
use warnings;
use Getopt::Long;
use ONMConfig;
use CNMScripts;
use Crawler::Store;
use Data::Dumper;
use JSON;

#-------------------------------------------------------------------------------------------
my $VERSION='1.0';
$FILE_CONF='/cfg/onm.conf';
my $cmd;

#-------------------------------------------------------------------------------------------
my $rCFG=conf_base($FILE_CONF);
my $conf_path=$rCFG->{'conf_path'}->[0];
my $txml_path=$rCFG->{'txml_path'}->[0];
my $app_path=$rCFG->{'app_path'}->[0];
my $dev_path=$rCFG->{'dev_path'}->[0];
my $store_path=$rCFG->{'store_path'}->[0];

my $db_server=$rCFG->{db_server}->[0];
my $db_name=$rCFG->{db_name}->[0];
my $db_user=$rCFG->{db_user}->[0];
my $db_pwd=$rCFG->{db_pwd}->[0];

my $host_name=$rCFG->{host_name}->[0];

#-----------------------------------------------------------------
my %OPTS = ();
my $SCRIPT=CNMScripts->new();
GetOptions (\%OPTS, 'in=s', 'help', 'v', 'log-level=s', 'log-mode=s', 'custom-field=s', 'dir-base=s') or die "$0: Parameter error. If you need help execute $0 -help\n";

if ($OPTS{'help'}) {
   $SCRIPT->usage($main::MYHEADER);
   exit 1;
}

my $VERBOSE = (defined $OPTS{'v'}) ? 1 : 0;
my $log_mode = (defined $OPTS{'log-mode'}) ? $OPTS{'log-mode'} : 1; # 1 => syslog | 2 => stdout | 3 => both
my $log_level = (defined $OPTS{'log-level'}) ? $OPTS{'log-level'} : 'info';
my $custom_field = (defined $OPTS{'custom-field'}) ? $OPTS{'custom-field'} : 'CNM-MAINTENANCE';
my $dir_base = (defined $OPTS{'dir-base'}) ? $OPTS{'dir-base'} : '/store/www-user/calendar';


#-----------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------
my ($tlast,$tdate,$rows,$rc,$rcstr)=(0,0,0,0,'');

my $store=Crawler::Store->new(db_server=>$db_server,db_name=>$db_name,db_user=>$db_user,db_pwd=>$db_pwd,host=>$host_name,cfg=>$rCFG, log_level=>$log_level, log_mode=>$log_mode );
$store->store_path($store_path);
my $dbh=$store->open_db();

#-------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------
my %params = ('custom_field'=>$custom_field, 'dir_base'=>$dir_base);
my $calendar_files = $store->get_maintenance_calendars($dbh,\%params);
my $id_devs = join ',', keys %{$calendar_files}; 
my $current = $store->get_device($dbh,{'id_dev'=>$id_devs},'status,ip');

if ($VERBOSE) { print Dumper($calendar_files); }
if ($VERBOSE) { print Dumper($current); }

#-----------------------------------------------------------------------------------------
my $i=-1;
my $json = JSON->new();
foreach my $id (sort keys %{$calendar_files}) {

	$i+=1;
	my $file_path = $calendar_files->{$id}->{'file'};
	my $dev_name = $calendar_files->{$id}->{'name'};

	if (! -f $file_path) {	
		$store->log('info',"**ERROR** File $file_path NOT Found $dev_name ($id)");
		next;
	}
	$store->log('debug',"CHECK [$id] $dev_name >> file=$file_path");

	my $jconf = $store->slurp_file($file_path);
	my $CAL = $json->decode($jconf);

	if ($VERBOSE) { 
		print "file_path=$file_path\n";
		print Dumper($CAL); 
	}

	my $inrange = $store->check_calendar($CAL->{'maintenance'});

	my $action='';
	if (($inrange == 0) && ($current->[$i][0] != 0)) { 
		my $ip = $current->[$i][1];
		$store->store_device($dbh,{'id_dev'=>$id, 'ip'=>$ip, 'status'=>0}); 
		my $rc = $store->error();
		$action="SET ACTIVE $dev_name ($id) rc=$rc";
		$store->log('info',"SET ACTIVE $dev_name ($id) rc=$rc");
	}
	elsif (($inrange == 1) && ($current->[$i][0] != 2)) { 
		my $ip = $current->[$i][1];
		$store->store_device($dbh,{'id_dev'=>$id, 'ip'=>$ip, 'status'=>2}); 
		my $rc = $store->error();
		$action="SET MAINTENANCE $dev_name ($id) rc=$rc";
		$store->log('info',"SET MAINTENANCE $dev_name ($id) rc=$rc");
	}

	print "[$id] $dev_name >> INRANGE=$inrange $action\n";
}

#$store->store_device($dbh,$data);

#-----------------------------------------------------------------------------------------
#     {"name":"inmonth-12", "month":"12", "mday":"1,28", "hhmm_start":"18h0m", "hhmm_end":"19h0m" },
#
#     {"name":"inday-year-0", "month_start":"1", "month_end":"1", "mday_start":"2", "mday_end":"2", "hhmm_start":"18h0m", "hhmm_end":"19h0m" },
#     {"name":"inday-day_period-1", "hhmm_start":"02h00m", "hhmm_end":"06h00m", "weekday":"*" },
#     {"name":"inday-2", "hhmm_start":"19h00m", "hhmm_end":"20h00m", "weekday":"TUE,WED,THU,FRY,SAT" },
#     {"name":"inday-3", "hhmm_start":"17h45m", "hhmm_end":"18h45m", "weekday":"SUN" },




#-------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------
sub get_diff {
my ($rres1,$rres2)=@_;
}

