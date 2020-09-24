#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME: cnm_app_cfg_monitor.pl
# AUTHOR: Fernando Marin <fmarin\@s30labs.com>
# DATE: 27/05/2019
# VERSION: 1.0
#
# DESCRIPTION:
# Permite activar|desactivar los monitores especificados en la seccion __DATA__ del script.
#
# USAGE:
# cnm_app_cfg_monitor.pl [-ip x.x.x.x] -set
# cnm_app_cfg_monitor.pl [-ip x.x.x.x] -clr
#
# -ip         : Opcional. Permite acsociar el script a un dispositivo.
# -set        : Activa monitores
# -clr        : Desactiva monitores
# -v/-verbose : Verbose output (debug)
# -h/-help    : Help
#
# </CNMDOCU>
#--------------------------------------------------------------------
MYHEADER
};

use lib "/opt/crawler/bin";
use strict;
use Getopt::Long;
use Data::Dumper;
use ONMConfig;
use CNMScripts;
use Crawler::Store;
use JSON;
use Encode qw(decode_utf8);
use ATypes;
use ProvisionLite;

#-------------------------------------------------------------------------------------------
my $TIMEOUT =900;
my $FILE_CONF='/cfg/onm.conf';
my ($rres,$sql,$HELP,$pIP, $pSet, $pClr, $VERBOSE,$cid,$plog_level)=([],'',0,'',0,0,0,'default','debug');

#-------------------------------------------------------------------------------------------
my $script = CNMScripts->new('timeout'=>$TIMEOUT);
my $ok = GetOptions( "help" => \$HELP, "h" => \$HELP, "ip=s"=>\$pIP, "set"=>\$pSet, "clr"=>\$pClr, "v"=>\$VERBOSE, "d=s"=>\$plog_level);
if (! $ok) {
   print STDERR "***ERROR EN EL PASO DE PARAMETROS***\n";
   $script->usage($main::MYHEADER);
   exit 1;
}

#-------------------------------------------------------------------------------------------
if ($HELP) { $script->usage($main::MYHEADER); }

my $SET = ($pClr) ? 0 : 1;
if ($VERBOSE) { print "SET=$SET\n"; }

my $log_level= (defined $plog_level) ? $plog_level : 'debug';
my $log_mode = ($VERBOSE) ? 3 : 1;

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

#-------------------------------------------------------------------------------------------
my $provision=ProvisionLite->new(log_level=>$log_level, log_mode=>$log_mode, cfg=>$rCFG);
$provision->init();
my $store=$provision->istore();
my $dbh=$provision->dbh();

#-------------------------------------------------------------------------------------------
my $json = JSON->new();
my $seed = get_data_cmd();
my $vseed = $json->decode($seed);
if ($VERBOSE) { print Dumper($vseed),"\n"; }

#-------------------------------------------------------------------------------------------
my %IDS=();
foreach my $h (@$vseed) {

	my $monitor_label = $h->{'monitor_label'};
	my $deviceip = $h->{'deviceip'};
	my $metric_label = $h->{'metric_label'};

	my $cond = '';
	if (exists $h->{'deviceip'}) { $cond = 'ip = "'.$h->{'deviceip'}.'"'; }
   $sql = "SELECT id_dev FROM devices WHERE $cond";
   $rres = $store->get_from_db_cmd($dbh,$sql);
   my $id_dev = $rres->[0][0];
	$IDS{$id_dev} = 1;	

	$sql = "SELECT subtype,monitor FROM alert_type WHERE cause like '%$monitor_label%'";
	$rres = $store->get_from_db_cmd($dbh,$sql);
	my $subtype = $rres->[0][0];
	my $monitor = $rres->[0][1];
#	if (($IDU !~ /^\d+$/) || ($IDU==0)) {
#   	die "**ERROR** $USER not defined\n";
#	}

	$sql = "SELECT id_tm2iid,status,label FROM prov_template_metrics2iid WHERE id_dev=$id_dev and mname='$subtype'";
	$rres = $store->get_from_db_cmd($dbh,$sql);
	my @id_tm2iid=();
	foreach my $v (@$rres) {
		push @id_tm2iid, $v->[0];
	}

	my $ids = join(',',@id_tm2iid);
	if (!$SET) { $monitor='0'; }
	$sql = "UPDATE prov_template_metrics2iid SET watch='$monitor' WHERE id_tm2iid IN ($ids)";
	$rres = $store->db_cmd($dbh,$sql);

	if ($SET) {
   	print "SET ($rres) >> $monitor_label ($deviceip): id_dev=$id_dev\tsubtype=$subtype\tmonitor=$subtype\t[ $ids ]\n";
	}
	else {
   	print "CLR ($rres) >> $monitor_label ($deviceip): id_dev=$id_dev\tsubtype=$subtype\tmonitor=$subtype\t[ $ids ]\n";
	}
	if ($VERBOSE) { print "---->$sql-----\n"; }
}


foreach my $id_dev (sort keys %IDS) {
	print "PROVISION DEVICE >> id_dev=$id_dev\n";
	$provision->prov_do_set_device_metric({'id_dev'=>$id_dev, 'init'=>0, 'cid'=>$cid});
}

#-------------------------------------------------------------------------------------------
$store->close_db($dbh);

#-------------------------------------------------------------------------------------------
sub get_data_cmd {

   local($/) = undef;
	my $raw = <DATA>;
	$raw =~ s/\r//g;
	$raw =~ s/\n//g;
   return $raw;
}


1;

__DATA__
[
	{
		"monitor_label":"XXXXX", 
		"deviceip":"x.x.x.x", 
		"metric_label":"XXXXX"
	}
]
