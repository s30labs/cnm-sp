#!/usr/bin/perl -w
#---------------------------------------------------------------------------
use lib '/opt/cnm/crawler/bin';
use lib '/opt/cnm/designer';
use lib '/opt/cnm/designer/proxy-pkgs';
use lib './proxy-pkgs';
use strict;
use Data::Dumper;
use File::Basename;
use Digest::MD5 qw(md5_hex);
use Getopt::Std;
use ONMConfig;
use Crawler::Store;

#-------------------------------------------------------------------------------------------
my $FILE_CONF='/cfg/onm.conf';
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


#---------------------------------------------------------------------------
my $DIR_BASE = '.';
#---------------------------------------------------------------------------
#---------------------------------------------------------------------------
my %opts=();
getopts("hvi:",\%opts);

if ($opts{h}) {
   my $USAGE = usage(); die $USAGE;
}

#---------------------------------------------------------------------------
my $log_level='info';
my $log_info=3;
my $store=Crawler::Store->new(db_server=>$db_server,db_name=>$db_name,db_user=>$db_user,db_pwd=>$db_pwd, log_level=>$log_level, log_info=>$log_info);
$store->store_path($store_path);
my $dbh=$store->open_db();


my %template = ('type' => 'xagent', 'subtype' => 'custom_11111000', 'watch' => 's_custom_11111000_1111100', 'iid' => 'ALL', 'mname' => 'custom_11111000', 'label' => 'P65-SP0009-KPI0001 - ACTIVCPT Job_DM_SID_ActivCptClient (app-ds-processes.local)', 'lapse' => '300', 'status' => 0);

print "id_dev=$id_dev\n";
$store->store_template_metrics($dbh,$id_dev,\%template);

#--------------------------------------------------------------------------------
sub usage {

   my @fpth = split ('/',$0,10);
   my @fname = split ('\.',$fpth[$#fpth],10);
   my $USAGE = <<USAGE;
Mapping metrics to devices/s using a mapping modue
hvm:b:

$fpth[$#fpth] -v  : Verbose
$fpth[$#fpth] -h  : Help message
$fpth[$#fpth] -m  : Specify Mapping module name (in BASE_DIR/proxy_pkgs directory)
$fpth[$#fpth] -b  : Sets BASE_DIR for designer code and proxy_pkgs modules

USAGE

}

