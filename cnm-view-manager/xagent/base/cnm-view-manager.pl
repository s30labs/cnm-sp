#!/usr/bin/perl -w
#-------------------------------------------------------------------------------------------
# user2view
#-------------------------------------------------------------------------------------------
use lib "/opt/crawler/bin";
use strict;
use Getopt::Long;
use Data::Dumper;
use ONMConfig;
use Crawler::Store;
use Encode qw(decode_utf8);

#-------------------------------------------------------------------------------------------
my $FILE_CONF='/cfg/onm.conf';
my ($rres,$sql,$HELP,$VIEW,$ID,$USER,$RECURSE)=([],'','','',0,'',0);
my ($CREATE,$FILL,$SECURE)=('','','');
my %PH=();
my %ALLV=();
my @ALL;

#-------------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $USAGE = <<USAGE;
cnm-view-manager.pl v1.0 (c) s30labs

$fpth[$#fpth] -create 02-Definicion-Vistas.csv
$fpth[$#fpth] -fill 03-Asociar-Metricas-a-Vistas.csv
$fpth[$#fpth] -help|-h

-create       View creation
-h|-help      Help 
USAGE

#-------------------------------------------------------------------------------------------
GetOptions( "help" => \$HELP, "h" => \$HELP, "create=s"=>\$CREATE,  "fill=s"=>\$FILL, "secure=s"=>\$SECURE,  "view=s"=>\$VIEW, "user=s"=>\$USER, "recurse"=>\$RECURSE)
  or die("$USAGE\n");

if ($HELP) { die("$USAGE\n"); }

#if ($VIEW eq '') { die("$USAGE\n"); }
my $VIEW8 = decode_utf8($VIEW, 1);
#if ($USER eq '') { die("$USAGE\n"); }

#-------------------------------------------------------------------------------------------
my $IP=my_ip();
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

my $store=Crawler::Store->new(db_server=>$db_server,db_name=>$db_name,db_user=>$db_user,db_pwd=>$db_pwd);
$store->store_path($store_path);
my $dbh=$store->open_db();

#-------------------------------------------------------------------------------------------
if ($CREATE) {

	my $file_cfg = verify_file($CREATE);
	if ($file_cfg eq '') { die "**ERROR** NO SE ACCEDE AL FICHERO $CREATE\n"; }

	my $rc = open (F, "<$file_cfg");
	if (! $rc) { print "**ERROR** NO SE ACCEDE AL FICHERO $file_cfg ($!)\n"; }
	else {
		while (<F>) {
			if ($_ =~ /^#/) { next; }
			$_ =~ s/\n//;
			$_ =~ s/\r//;
			my @cols = split(';', $_);
			create_update_view(\@cols);
		}
		close F;
	}
}

#-------------------------------------------------------------------------------------------
if ($FILL) {

   my $file_cfg = verify_file($FILL);
   if ($file_cfg eq '') { die "**ERROR** NO SE ACCEDE AL FICHERO $FILL\n"; }

   if (! -f $file_cfg) {
      print "**ERROR** NO SE ACCEDE AL FICHERO $file_cfg\n";
   }
   else {
      my $rc = open (F, "<$file_cfg");
      if (! $rc) { print "**ERROR** NO SE ACCEDE AL FICHERO $file_cfg ($!)\n"; }
      else {
         while (<F>) {
				if ($_ =~ /^#/) { next; }
				$_ =~ s/\n//;
				$_ =~ s/\r//;
            my @cols = split(';', $_);
            fill_view(\@cols);
         }
         close F;
      }
   }


}

#-------------------------------------------------------------------------------------------
if ($SECURE) {


$sql = "SELECT id_user from cfg_users WHERE login_name='$USER'";
$rres = $store->get_from_db_cmd($dbh,$sql);
my $IDU = $rres->[0][0];
if (($IDU !~ /^\d+$/) || ($IDU==0)) {
   die "**ERROR** $USER not defined\n";
}

$sql = "SELECT id_cfg_view,name,cid,cid_ip from cfg_views";
$rres = $store->get_from_db_cmd($dbh,$sql);
foreach my $v (@$rres) {
   $ALLV{$v->[0]}={'name'=>$v->[1], 'cid'=>$v->[2], 'cid_ip'=>$v->[3]};
   if ($v->[1]=~/$VIEW8/) { $ID=$v->[0]; }
}
print "VIEW:$VIEW ID=$ID\n";

$sql = 'SELECT id_cfg_view,id_cfg_subview FROM cfg_views2views';
$rres = $store->get_from_db_cmd($dbh,$sql);

foreach my $v (@$rres) {
   my $id_cfg_view=$v->[0];
   my $id_cfg_subview=$v->[1];
   if (exists $PH{$id_cfg_view}) { push @{$PH{$id_cfg_view}}, $id_cfg_subview; }
   else { $PH{$id_cfg_view} = [$id_cfg_subview];  }
}

if ($ID==0) { die "**ERROR** View $VIEW not found ...\n"; }

my @ALL=($ID);
if ($RECURSE) { itera($PH{$ID}); }
#print Dumper(\@ALL);

my $n=scalar(@ALL);
print "$n views found ...\n";

foreach my $id (@ALL) {

   my $cid=$ALLV{$id}->{'cid'};
   my $cid_ip=$ALLV{$id}->{'cid_ip'};
   print "Grant access to user $USER ($IDU) in $ALLV{$id}->{'name'} ($id) [$IDU,$id,$USER,$cid,$cid_ip]...\n";
   $store->insert_to_db($dbh,'cfg_user2view',{'id_user'=>$IDU,'id_cfg_view'=>$id,'login_name'=>$USER,'cid'=>$cid,'cid_ip'=>$cid_ip});
}
}


#-------------------------------------------------------------------------------------------
$store->close_db($dbh);

#-------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------
sub create_update_view {
my ($p) = @_;

	my ($descr, $type, $itil, $top) = ($p->[0], $p->[1], $p->[2], $p->[3]);
	my ($rc,$rres,$sql);

	# itil_type: operacion 1, configuracion 2, capacidad 3, disponibilidad 4, seguridad 5
	my $itil_type = 1;
	if ($itil =~ /configuracion/i) { $itil_type = 2; }
	elsif ($itil =~ /capacidad/i) { $itil_type = 3; }
	elsif ($itil =~ /disponibilidad/i) { $itil_type = 4; }
	elsif ($itil =~ /seguridad/i) { $itil_type = 5; }

	$sql = "INSERT INTO cfg_views (name,type,itil_type,cid,cid_ip) VALUES ('$descr','$type','$itil_type','default','$IP')";
	$rc = $store->db_cmd($dbh,$sql);
	if ($store->error()) {
		my $errorstr = $store->errorstr();
		if ($errorstr =~/Duplicate entry/) { 
			print "Already exists View $descr | $type\n";
		}
		else {
			print "[**ERROR**] Create View $descr | $type >> $errorstr\n";
			return;
		}
	}
	else {
		print "[OK] Created View $descr | $type ($rc)\n"; 
	}

	if (($top eq 'TOP') or ($top eq 'top')) { return; }

	$sql = "SELECT id_cfg_view FROM cfg_views WHERE name='$descr'";
	$rres = $store->get_from_db_cmd($dbh,$sql);
	my $ID = $rres->[0][0];

   $sql = "SELECT id_cfg_view FROM cfg_views WHERE name='$top'";
   $rres = $store->get_from_db_cmd($dbh,$sql);
   my $IDTOP = $rres->[0][0];

	$sql = "INSERT INTO cfg_views2views (id_cfg_view,cid_view,cid_ip_view,id_cfg_subview,cid_subview,cid_ip_subview) VALUES ($IDTOP,'default','$IP',$ID,'default','$IP')";

   $rc = $store->db_cmd($dbh,$sql);
   if ($store->error()) {
      my $errorstr = $store->errorstr();
      if ($errorstr =~/Duplicate entry/) {
         print "Already exists View $descr as subview from $top\n";
      }
		else {
      	print "[**ERROR**] Create View $descr as subview from $top >> $errorstr\n";
      	return;
		}
   }
	else {
   	print "[OK] Create View $descr ($ID) as subview from $top ($IDTOP) ($rc)\n";
	}

#+-------------+----------+--------------+----------------+-------------+----------------+-----------+---------+
#| id_cfg_view | cid_view | cid_ip_view  | id_cfg_subview | cid_subview | cid_ip_subview | graph     | size    |
#+-------------+----------+--------------+----------------+-------------+----------------+-----------+---------+
#|          58 | default  | 192.168.57.9 |             59 | default     | 192.168.57.9   |  50000050 | 450x210 |
#|          58 | default  | 192.168.57.9 |             60 | default     | 192.168.57.9   |  50000540 | 450x210 |

#   $self->error($libSQL::err);
#   $self->errorstr($libSQL::errstr);
#   $self->lastcmd($libSQL::cmd);

}

#+-------------+-----------+-----------+-------+---------+
#| id_cfg_view | id_metric | id_device | graph | size    |
#+-------------+-----------+-----------+-------+---------+
#|           2 |       713 |        38 |  NULL | 350x100 |
#+-------------+-----------+-----------+-------+---------+

#-------------------------------------------------------------------------------------------
sub fill_view {
my ($params) = @_;
my ($p) = @_;

   my ($view_name, $dev_name, $subtype, $metric_name) = ($p->[0], $p->[1], $p->[2], $p->[3]);
   my ($rc,$rres,$sql);

   $sql = "SELECT id_cfg_view,cid,cid_ip FROM cfg_views WHERE name='$view_name'";
   $rres = $store->get_from_db_cmd($dbh,$sql);
   my $id_cfg_view = $rres->[0][0];
   my $cid = $rres->[0][1];
   my $cid_ip = $rres->[0][2];

	if ($id_cfg_view !~/^\d+$/) { 
		print "**ERROR** NO EXISTE VISTA $view_name\n";
		return;
	}

   $sql = "SELECT id_dev FROM devices WHERE name='$dev_name'";
   $rres = $store->get_from_db_cmd($dbh,$sql);
   my $id_dev = $rres->[0][0];

   if ($id_dev !~/^\d+$/) {
      print "**ERROR** NO EXISTE DISPOSITIVO $dev_name\n";
      return;
   }


   $sql = "SELECT id_metric FROM metrics WHERE id_dev=$id_dev AND subtype='$subtype'";
   $rres = $store->get_from_db_cmd($dbh,$sql);
   my $id_metric = $rres->[0][0];

   if ($id_metric !~/^\d+$/) {
      print "**ERROR** NO EXISTE METRICA $metric_name ASOCIADA A DISPOSITIVO $dev_name\n";
      return;
   }

   $sql = "INSERT INTO cfg_views2metrics (id_cfg_view,id_metric,id_device,size) VALUES ($id_cfg_view,$id_metric,$id_dev,'350x100')";

   $rc = $store->db_cmd($dbh,$sql);
   if ($store->error()) {
      my $errorstr = $store->errorstr();
      if ($errorstr =~/Duplicate entry/) {
         print "Already exists metric $metric_name in view $view_name\t";
      }
      else {
         print "[**ERROR**] Associate metric $metric_name to view $view_name >> $errorstr\n";
         return;
      }
   }
   else {
      print "[OK] Associate metric $metric_name to view $view_name ($rc)\t";
   }


	# Se actualiza nmetrics en cfg_views
	$sql = "SELECT count(DISTINCT a.id_metric) as cuantos FROM cfg_views2metrics a,devices b WHERE a.id_device=b.id_dev AND id_cfg_view=$id_cfg_view";
   $rres = $store->get_from_db_cmd($dbh,$sql);
   my $nmetrics = $rres->[0][0];

	$sql = "UPDATE cfg_views SET nmetrics=$nmetrics WHERE id_cfg_view=$id_cfg_view AND cid='$cid' AND cid_ip='$cid_ip'";
   $rc = $store->db_cmd($dbh,$sql);

	if ($store->error()) {
		my $errorstr = $store->errorstr();
		print "**error** updating nmetrics=$nmetrics\n";
	}
	else { print "nmetrics=$nmetrics\n"; }		


}

#-------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------
sub itera {
my ($vector) = @_;
   foreach my $id (@{$vector}) {
      push @ALL,$id;
      itera($PH{$id});
   }
}


#-------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------
sub verify_file {
my ($file) = @_;

	my $base_path = '/store/www-user/automation';
	my $file_verified = '';
	if (-f $file) { $file_verified = $file; }
	else {
		my $fpath = join('/', $base_path,$file);
		if (-f $fpath) { $file_verified = $fpath; }
	}

	return $file_verified;
}

