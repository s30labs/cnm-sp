#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME: linux_app_check_remote_cfgs.pl
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
# ./linux_app_check_remote_cfgs.pl -n 10.197.215.21
# xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# file_last=/opt/data/app-data/remote_cfgs/10.197.215.21/10.197.215.21-4444
# file_previous=/opt/data/app-data/remote_cfgs/10.197.215.21/10.197.215.21-1234
#
# --- /opt/data/app-data/remote_cfgs/10.197.215.21/10.197.215.21-4444     Fri Apr  6 10:01:04 2012
# +++ /opt/data/app-data/remote_cfgs/10.197.215.21/10.197.215.21-1234     Fri Apr  6 09:59:25 2012
# @@ -45,7 +45,7 @@
# !
#  ip dhcp pool POOLD
#     network 10.247.21.0 255.255.255.0
# -   dns-server 10.1.101.22 10.1.100.24
# +   dns-server 10.1.101.202 10.1.100.24
#     default-router 10.247.21.254
#     option 150 ip 10.29.0.236
#     lease 0 1
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
use CNMScripts::StoreConfig;
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
$0. $VERSION

$fpth[$#fpth] -n IP [-v]
$fpth[$#fpth] -h  : Ayuda

-n		IP del equipo
USAGE

#--------------------------------------------------------------------------------------
my $VERBOSE=0;
my %opts=();
getopts("hvn:",\%opts);

if ($opts{h}) { die $USAGE;}
my $ip=$opts{n} || die $USAGE;

if ($opts{v}) { $VERBOSE=1; }

#--------------------------------------------------------------------------------------
my $store = CNMScripts::StoreConfig->new();
if ( (exists $opts{l}) && ($opts{l}=~/\d+/) ) { $store->store_limit($opts{l}); }
my $result = $store->check_files($ip);


# ----------------------------------------------------------------------------------
# SE GENERA LA SALIDA
# ----------------------------------------------------------------------------------
my @COL_MAP = (
   { 'label'=>'DATOS ALMACENADOS', 'width'=>'20' , 'name_col'=>'file',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'NUM+', 'width'=>'5' , 'name_col'=>'ins',  'sort'=>'text', 'align'=>'left', 'filter'=>'#numeric_filter' },
   { 'label'=>'NUM-', 'width'=>'5' , 'name_col'=>'del',  'sort'=>'text', 'align'=>'left', 'filter'=>'#numeric_filter' },
   { 'label'=>'DIFERENCIAS', 'width'=>'*' , 'name_col'=>'changes',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
);

print encode_json($result). "\n";
my $col_map=encode_json(\@COL_MAP);
print "$col_map\n";



#--------------------------------------------------------------------------------------
sub verbose {
my ($msg)=@_;

	if ($VERBOSE) {print STDERR "$msg\n"; }
}

