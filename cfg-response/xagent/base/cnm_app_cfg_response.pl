#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME: cnm_app_cfg_response.pl
# AUTHOR: Fernando Marin <fmarin\@s30labs.com>
# DATE: 27/05/2019
# VERSION: 1.0
#
# DESCRIPTION:
# Permite activar|desactivar los monitores especificados en la seccion __DATA__ del script.
#
# USAGE:
# cnm_app_cfg_response.pl [-ip x.x.x.x] -set
# cnm_app_cfg_response.pl [-ip x.x.x.x] -clr
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
my ($rres,$sql,$HELP,$pIP, $pSet, $pClr, $VERBOSE,$cid,$plog_level,$i,$test)=([],'',0,'',0,0,0,'default','debug',0,0);

#-------------------------------------------------------------------------------------------
my $script = CNMScripts->new('timeout'=>$TIMEOUT);
my $ok = GetOptions( "help" => \$HELP, "h" => \$HELP, "ip=s"=>\$pIP, "set"=>\$pSet, "clr"=>\$pClr, "v"=>\$VERBOSE, "d=s"=>\$plog_level, "test"=>\$test);
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
my $cnt=1;
foreach my $h (@$vseed) {

	my $monitor_label = $h->{'monitor_label'};
	my $notification_label = $h->{'notification_label'};
	#my @transports = split(',', $h->{'transport'});
	my @transports = map {"'$_'"} split(',', $h->{'transport'});
	my $transport = join (',', @transports);
	
	my $deviceip = $h->{'deviceip'};

	my $type = $h->{'type'};
	my $type_app = $h->{'type_app'};
	my $type_run = $h->{'type_run'};
	my $type_mwatch = $h->{'type_mwatch'};
	my $severity = $h->{'severity'};
	my $wsize = $h->{'wsize'};
	my $template = $h->{'template'};
	my $title_template = $h->{'title_template'};

   $sql = "SELECT id_alert_type,monitor,subtype FROM alert_type WHERE cause like '%$monitor_label%'";
   $rres = $store->get_from_db_cmd($dbh,$sql);
   my $id_alert_type = $rres->[0][0];
   my $monitor = $rres->[0][1];
   my $subtype = $rres->[0][2];

	if ($VERBOSE) { print "id_alert_type=$id_alert_type\tmonitor=$monitor\n"; }

   $sql = "SELECT id_cfg_notification FROM cfg_notifications WHERE name like '%$notification_label%'";
   $rres = $store->get_from_db_cmd($dbh,$sql);
   my $id_cfg_notification = $rres->[0][0];

   if ($VERBOSE) { print "id_cfg_notification=$id_cfg_notification\n"; }

	#----------------------------------------------------------------------------------------
	# STORE response
	#----------------------------------------------------------------------------------------
	my $new=0;
	if ((defined $id_cfg_notification) && ($id_cfg_notification=~/\d+/)) {
		$sql = "UPDATE cfg_notifications SET monitor='$monitor', type=$type, type_app=$type_app, type_run=$type_run, type_mwatch=$type_mwatch, name='$notification_label', id_alert_type=$id_alert_type,severity=$severity,wsize=$wsize,template='$template',title_template='$title_template' WHERE id_cfg_notification=$id_cfg_notification";
		$rres = $store->db_cmd($dbh,$sql);

		if ($VERBOSE) { print "($rres) $sql\n"; }
	}
	else {
		$sql ="INSERT INTO cfg_notifications (monitor,type,type_app,type_run,type_mwatch,name,id_alert_type,severity,wsize,template,title_template) VALUES ('$monitor','$type','$type_app','$type_run','$type_mwatch','$notification_label','$id_alert_type','$severity',$wsize,'$template','$title_template')";
		$rres = $store->db_cmd($dbh,$sql);

		if ($VERBOSE) { print "($rres)$sql\n"; }

		$sql ="SELECT LAST_INSERT_ID() AS last";
   	$rres = $store->get_from_db_cmd($dbh,$sql);
   	$id_cfg_notification = $rres->[0][0];

		$new=1;
	}

	if ($VERBOSE) { print "id_cfg_notification=$id_cfg_notification\tnew=$new\n"; }

	if ($new) {
		print "$cnt\t**NEW** NOTIFICATION [$id_cfg_notification] STORED >> $notification_label\n";
	}
	else {
      print "$cnt\tNOTIFICATION [$id_cfg_notification] STORED >> $notification_label\n";
   }
	print '-'x90,"\n";
		
	$cnt++;

	# En modo test solo se crea/actualiza la respuesta a alertas
	if ($test) { next; }

	#----------------------------------------------------------------------------------------
	# Transports
	#----------------------------------------------------------------------------------------
	$sql ="SELECT id_register_transport,value FROM cfg_register_transports WHERE value IN ($transport)";
	if ($VERBOSE) { print "id_cfg_notification=$id_cfg_notification\n"; }

   $rres = $store->get_from_db_cmd($dbh,$sql);
	my @id_transports=();
	my @value_transports=();
	foreach my $x (@$rres) { 
		push @id_transports, $x->[0]; 
		push @value_transports, $x->[1]; 
	}

	$sql ="DELETE FROM cfg_notification2transport WHERE id_cfg_notification IN ($id_cfg_notification)";
   $rres = $store->db_cmd($dbh,$sql);
	if ($VERBOSE) { print "($rres)$sql\n"; }

	$i=0;
	foreach my $id_transport (@id_transports) {
		$sql ="INSERT INTO cfg_notification2transport (id_cfg_notification,id_register_transport) VALUES ($id_cfg_notification,$id_transport)";
		$rres = $store->db_cmd($dbh,$sql);
		if ($VERBOSE) { print "($rres)$sql\n"; }

		print "[$id_cfg_notification] TRANSPORT [$id_transport] $value_transports[$i] >> NOTIFICATION\n";
		$i++;
	}



	#----------------------------------------------------------------------------------------
	# APPs
	#----------------------------------------------------------------------------------------

	#----------------------------------------------------------------------------------------
	# notification2device
	#----------------------------------------------------------------------------------------
	#OJO Hay que verificar que la metrica esta asociada al dipositivo que se indica.
	if (! exists $h->{'deviceip'}) { next; }
	my @ips = map {"'$_'"} split (',', $h->{'deviceip'});
	my $cond = 'ip IN ('.join (',',@ips).')';

   $sql = "SELECT id_dev FROM devices WHERE $cond";
   $rres = $store->get_from_db_cmd($dbh,$sql);
	my @id_devs = ();
	foreach my $h (@$rres) { push @id_devs, $h->[0]; }

	$i=0;
	foreach my $id_dev (@id_devs) {
		if ($id_dev !~ /^\d+$/) { print "**ERROR CON id_dev=$id_dev***\n"; next; }

		my $iid='ALL';
		my $hiid='5fb1f955b45e38e31789';
		my $status=0;

		$sql = "INSERT IGNORE INTO cfg_notification2device (id_cfg_notification,id_device,status,iid,hiid,mname) values ($id_cfg_notification,$id_dev,$status,'$iid','$hiid','$subtype')";

		$rres = $store->db_cmd($dbh,$sql);
      if ($VERBOSE) { print "($rres)$sql\n"; }
		print "[$id_cfg_notification] NOTIFICATION >> DEVICE [$id_dev] $ips[$i]\n";
		$i++;
   }


#
#	if ($SET) {
#   	print "SET ($rres) >> $monitor_label ($deviceip): id_dev=$id_dev\tsubtype=$subtype\tmonitor=$subtype\t[ $ids ]\n";
#	}
#	else {
#   	print "CLR ($rres) >> $monitor_label ($deviceip): id_dev=$id_dev\tsubtype=$subtype\tmonitor=$subtype\t[ $ids ]\n";
#	}
#	if ($VERBOSE) { print "---->$sql-----\n"; }

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
      "monitor_label":"Alert in P01-SP0001-KPI0010",
      "notification_label":"Minor Alert in P01-SP0001-KPI0010 - PO not send from EDICOM to vendors",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"1.1.1.4",

      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"3",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },
   {
      "monitor_label":"Alert in P01-SP0001-KPI0010",
      "notification_label":"Major Alert in P01-SP0001-KPI0010 - PO not send from EDICOM to vendors",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"1.1.1.4",

      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"2",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },
   {
      "monitor_label":"Alert in P01-SP0001-KPI0010",
      "notification_label":"Critical Alert in P01-SP0001-KPI0010 - PO not send from EDICOM to vendors",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"1.1.1.4",

      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"1",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },

   {
      "monitor_label":"Alert in P01-SP0007-KPI0001",
      "notification_label":"Minor Alert in P01-SP0007-KPI0001 - Invoices not send from VOXEL to credit customer",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"192.168.59.38",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"3",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },
   {
      "monitor_label":"Alert in P01-SP0007-KPI0001",
      "notification_label":"Major Alert in P01-SP0007-KPI0001 - Invoices not send from VOXEL to credit customer",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"192.168.59.38",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"2",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },
   {
      "monitor_label":"Alert in P01-SP0007-KPI0001",
      "notification_label":"Critical Alert in P01-SP0007-KPI0001 - Invoices not send from VOXEL to credit customer",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"192.168.59.38",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"1",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },


   {
      "monitor_label":"Alert in P01-SP0007-KPI0002",
      "notification_label":"Minor Alert in P01-SP0007-KPI0002 - Invoices (EDIFACT format) not sent from EDICOM to credit customer",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"192.168.59.38",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"3",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },
   {
      "monitor_label":"Alert in P01-SP0007-KPI0002",
      "notification_label":"Major Alert in P01-SP0007-KPI0002 - Invoices (EDIFACT format) not sent from EDICOM to credit customer",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"192.168.59.38",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"2",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },
   {
      "monitor_label":"Alert in P01-SP0007-KPI0002",
      "notification_label":"Critical Alert in P01-SP0007-KPI0002 - Invoices (EDIFACT format) not sent from EDICOM to credit customer",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"192.168.59.38",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"1",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },

   {
      "monitor_label":"Alert in P01-SP0007-KPI0003",
      "notification_label":"Minor Alert in P01-SP0007-KPI0003 - Invoices (FACTURAE format) not sent from EDICOM to credit customer",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"192.168.59.38",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"3",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },
   {
      "monitor_label":"Alert in P01-SP0007-KPI0003",
      "notification_label":"Major Alert in P01-SP0007-KPI0003 - Invoices (FACTURAE format) not sent from EDICOM to credit customer",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"192.168.59.38",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"2",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },
   {
      "monitor_label":"Alert in P01-SP0007-KPI0003",
      "notification_label":"Critical Alert in P01-SP0007-KPI0003 - Invoices (FACTURAE format) not sent from EDICOM to credit customer",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"192.168.59.38",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"1",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },


   {
      "monitor_label":"Alert in P02-SP0002-KPI0002",
      "notification_label":"Minor Alert in P02-SP0002-KPI0002 - SAPtoDU master data integration inconsistences",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"192.168.69.142",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"3",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },
   {
      "monitor_label":"Alert in P02-SP0002-KPI0002",
      "notification_label":"Major Alert in P02-SP0002-KPI0002 - SAPtoDU master data integration inconsistences",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"192.168.69.142",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"2",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },
   {
      "monitor_label":"Alert in P02-SP0002-KPI0002",
      "notification_label":"Critical Alert in P02-SP0002-KPI0002 - SAPtoDU master data integration inconsistences",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"192.168.69.142",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"1",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },


   {
      "monitor_label":"Alert in P02-SP0002-KPI0003",
      "notification_label":"Minor Alert in P02-SP0002-KPI0003 - SAPtoDU last integration process execution",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"192.168.69.142",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"3",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },
   {
      "monitor_label":"Alert in P02-SP0002-KPI0003",
      "notification_label":"Major Alert in P02-SP0002-KPI0003 - SAPtoDU last integration process execution",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"192.168.69.142",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"2",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },
   {
      "monitor_label":"Alert in P02-SP0002-KPI0003",
      "notification_label":"Critical Alert in P02-SP0002-KPI0003 - SAPtoDU last integration process execution",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"192.168.69.142",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"1",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },


   {
      "monitor_label":"Alert in P04-SP0004-KPI0019",
      "notification_label":"Critical Alert in P04-SP0004-KPI0019 - Response Time Mambo Supply Syncro 2",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"10.101.40.230",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"1",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },


   {
      "monitor_label":"Alert in P04-SP0004-KPI0020",
      "notification_label":"Critical Alert in P04-SP0004-KPI0020 - Tables failed Mambo Supply Syncro 2",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"10.101.40.230",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"1",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },


   {
      "monitor_label":"Alert in P04-SP0004-KPI0023",
      "notification_label":"Critical Alert in P04-SP0004-KPI0023 - Response Time Mambo Supply Syncro 3",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"10.103.100.220",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"1",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },

   {
      "monitor_label":"Alert in P04-SP0004-KPI0024",
      "notification_label":"Critical Alert in P04-SP0004-KPI0024 - Tables failed Mambo Supply Syncro 3",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"10.103.100.220",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"1",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },


   {
      "monitor_label":"Alert in P04-SP0007-KPI0001",
      "notification_label":"Minor Alert in P04-SP0007-KPI0001 - Failed processes VTOM - TJBWESSALESMETAC",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"1.1.1.6",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"3",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },
   {
      "monitor_label":"Alert in P04-SP0007-KPI0001",
      "notification_label":"Major Alert in P04-SP0007-KPI0001 - Failed processes VTOM - TJBWESSALESMETAC",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"1.1.1.6",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"2",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },
   {
      "monitor_label":"Alert in P04-SP0007-KPI0001",
      "notification_label":"Critical Alert in P04-SP0007-KPI0001 - Failed processes VTOM - TJBWESSALESMETAC",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"1.1.1.6",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"1",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },


   {
      "monitor_label":"Alert in P04-SP0007-KPI0002",
      "notification_label":"Minor Alert in P04-SP0007-KPI0002 - Process execution time VTOM - TJBWESSALESMETAC",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"1.1.1.6",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"3",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },
   {
      "monitor_label":"Alert in P04-SP0007-KPI0002",
      "notification_label":"Major Alert in P04-SP0007-KPI0002 - Process execution time VTOM - TJBWESSALESMETAC",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"1.1.1.6",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"2",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   },
   {
      "monitor_label":"Alert in P04-SP0007-KPI0002",
      "notification_label":"Critical Alert in P04-SP0007-KPI0002 - Process execution time VTOM - TJBWESSALESMETAC",
      "transport":"cnmsupport@s30labs.com,imo@areas.com",
      "deviceip":"1.1.1.6",
      "type":"0",
      "type_app":"0",
      "type_run":"0",
      "type_mwatch":"1",
      "severity":"1",
      "wsize":"0",
      "template":"__EMPTY__",
      "title_template":""
   }

]
