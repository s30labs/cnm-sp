#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_app_get_conf_telnet_cisco_router.pl
#
# DESCRIPTION:
# Obtiene por TELNET el fichero de configuracion de un router CISCO con IOS
#
# CALLING SAMPLE:
# linux_app_get_conf_telnet_cisco_router.pl -n 1.1.1.1 -u user -p pwd
#
# INPUT (PARAMS):
# a. -n  :  IP remota
# b. -u  :  Usuario
# c. -p  :  Clave
# d. -e  :  Clave de enable
# e. -l	:	Limite de ficheros a almacenar
#
# OUTPUT (STDOUT):
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
use Net::Telnet;
use Net::Telnet::Cisco;
use CNMScripts::StoreConfig;
use Stdout;
use JSON;

#--------------------------------------------------------------------------------------
# Limite de ficheros almacenados (es tambien parametro de entrada)
my $STORE_LIMIT=10;

#--------------------------------------------------------------------------------------
my $CMD1 = <<END1;
show running-config
END1

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
linux_app_get_conf_telnet_cisco_router.pl $VERSION

$fpth[$#fpth] -n IP [-u user] -p pwd [-e pwd] [-v]
$fpth[$#fpth] -h  : Ayuda

-n    IP remota/local
-u    user
-p    pwd
-e    pwd de enable
-l    Limite de Ficheros almacenados (por defecto es 10)
USAGE

#--------------------------------------------------------------------------------------
my $VERBOSE = 0;
my %opts=();
getopts("hvn:u:p:e:l:",\%opts);

if ($opts{h}) { die $USAGE;}
my $ip=$opts{n} || die $USAGE;

my $user=$opts{u};
my $pwd=$opts{p};
if ($opts{v}) { $VERBOSE=1; }
if ( (exists $opts{l}) && ($opts{l}=~/\d+/) ) { $STORE_LIMIT = $opts{l}; }

#--------------------------------------------------------------------------------------
# SE PROCESA EL COMANDO
#--------------------------------------------------------------------------------------
my @cmds=($CMD1);
my ($stdout, $stderr, $exit) = ('', '', 0);
my @lines=();
my $TIMEOUT=5;

my $t = new Net::Telnet::Cisco (Timeout => $TIMEOUT);
$t->open($ip);

$t->login($user, $pwd);

my $ok=1;
if (exists $opts{e}) { $ok=$t->enable($opts{e}); }
if (! $ok) {
   print "No se ha obtenido la configuracion de $ip (ERROR EN enable)\n";
	exit;
}

foreach my $cmd (@cmds) {

   verbose("CMD=$cmd");

   @lines = $t->cmd($cmd);
   #print @lines;
}

#--------------------------------------------------------------------------------------
if (scalar(@lines) == 0) {
   print "No se ha obtenido la configuracion de $ip\n";
   exit;
}


#--------------------------------------------------------------------------------------
my $store = CNMScripts::StoreConfig->new();
$store->store_limit($STORE_LIMIT);
my $result = $store->store_file($ip,\@lines);


# ----------------------------------------------------------------------------------
# SE GENERA LA SALIDA
# ----------------------------------------------------------------------------------
my @COL_MAP = (
   { 'label'=>'RC', 'width'=>'5' , 'name_col'=>'rc',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'INFO', 'width'=>'20' , 'name_col'=>'rcstr',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'FICHERO', 'width'=>'*' , 'name_col'=>'file',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
   { 'label'=>'CAMBIOS', 'width'=>'*' , 'name_col'=>'changes',  'sort'=>'text', 'align'=>'left', 'filter'=>'#text_filter' },
);

my @COL_DATA=();
push @COL_DATA,$result;
print encode_json(\@COL_DATA). "\n";
my $col_map=encode_json(\@COL_MAP);
print "$col_map\n";


#--------------------------------------------------------------------------------------
sub verbose {
my ($msg)=@_;

   if ($VERBOSE) {print STDERR "$msg\n"; }
}

