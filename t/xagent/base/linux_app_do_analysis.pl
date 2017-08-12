#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME: linux_app_do_analysis.pl
#
# DESCRIPTION:
# Recorre el directorio donde se han almacenado las diferentes configuraciones de un dispositivo.
# Presenta las diferencias que existen entre ellas en orden cronologico 
#
# CALLING SAMPLE:
# linux_app_check_remote_cfgs.pl -n 1.1.1.1 
# linux_metric_ssh_files_in_dir.pl -h  : Ayuda
#
# INPUT (PARAMS):
# a. -n  :  IP remota
#
# OUTPUT (STDOUT):
#
#
# OUTPUT (STDERR):
# Error info, warnings etc... If verbose also debug info.
#
# EXIT CODE:
#  0: OK
# -1: System error
# >0: Script error
#--------------------------------------------------------------------------------------
use lib '/opt/crawler/bin/';
use strict;
use Getopt::Std;
use Stdout;
use CNMScripts::DataAnalysis;
use JSON;

#--------------------------------------------------------------------------------------
# Directorio donde se almacenan las configuraciones
my $STORE_DIR='/opt/data/app-data/remote_cfgs';

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
ssh2cmd. $VERSION

$fpth[$#fpth] -n IP [-w xml] [-v]
$fpth[$#fpth] -h  : Ayuda

-n		IP del equipo
USAGE

#--------------------------------------------------------------------------------------
my $VERBOSE=0;
my %opts=();
getopts("hvn:",\%opts);

if ($opts{h}) { die $USAGE;}
#my $ip=$opts{n} || die $USAGE;

if ($opts{v}) { $VERBOSE=1; }

#--------------------------------------------------------------------------------------
my $da=CNMScripts::DataAnalysis->new();
my $dbh = $da->dbConnect();

if ($da->err_num() != 0) {
   my $err_num=$da->err_num();
   my $err_str=$da->err_str();
   print "ERROR EN CONX DB ($err_num): $err_str\n";
   exit 0;
}

$da->do_analysis($dbh);







## ----------------------------------------------------------------------------------
## SE GENERA LA SALIDA
## ----------------------------------------------------------------------------------
#my @COL_MAP = (
#   { 'label'=>'FECHA1', 'width'=>'10' , 'name_col'=>'date1',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
#   { 'label'=>'FECHA2', 'width'=>'10' , 'name_col'=>'date2',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
#   { 'label'=>'DIFERENCIAS', 'width'=>'*' , 'name_col'=>'changes',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
#);
#
#print encode_json($result). "\n";
#my $col_map=encode_json(\@COL_MAP);
#print "$col_map\n";


