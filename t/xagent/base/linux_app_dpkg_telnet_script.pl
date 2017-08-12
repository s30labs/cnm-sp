#!/usr/bin/perl -w
#--------------------------------------------------------------------
# NAME:  linux_dpkg_telnet_script.pl
#
# DESCRIPTION:
# Ejecuta un script en un host remoto mediante Telnet 
#
# CALLING SAMPLE:
# linux_dpkg_telnet_script.pl -n localhost [-a pattern] [-v]
# linux_dpkg_telnet_script.pl -n 1.1.1.1 -c "-user=aaa -pwd=bbb" [-a pattern] [-v]
# linux_dpkg_telnet_script.pl -h  : Ayuda
#
# INPUT (PARAMS):
# -n  :  IP remota
# -c  :  Credenciales
#
# OUTPUT (STDOUT):
#
# ii  xauth                               1:1.0.4-1                    X authentication utility
# ii  xbitmaps                            1.1.0-1                      Base X bitmaps
# ii  xfonts-encodings                    1:1.0.3-1                    Encodings for X.Org fonts
#
# OUTPUT (STDERR):
# Error info, warnings etc... If verbose also debug info.
#
# EXIT CODE:
#  0: OK
# -1: System error
# >0: Script error
#--------------------------------------------------------------------
use lib '/opt/crawler/bin/';
use strict;
use Getopt::Std;
use CNMScripts::Telnet;
use Stdout;
use Time::HiRes qw(gettimeofday tv_interval);
use Data::Dumper;

#--------------------------------------------------------------------
#--------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
linux_dpkg_telnet_script.pl. $VERSION

$fpth[$#fpth] -n localhost -a pattern [-v]
$fpth[$#fpth] -n IP -a pattern -c "-user=aaa -pwd=bbb" [-v]
$fpth[$#fpth] -h  : Ayuda

-n		IP remota/local
-c		Credenciales Telnet
-a 	Patron de busqueda
-v		Verbose
USAGE

#--------------------------------------------------------------------
my $local_ip = my_ip();
my $local=0;
my ($pattern,$VERBOSE)=('.',0);

#--------------------------------------------------------------------
my %opts=();
getopts("hvn:c:a:",\%opts);

if ($opts{h}) { die $USAGE;}
my $ip=$opts{n} || die $USAGE;
if ( ($ip eq 'localhost') || ($ip eq '127.0.0.1') || ($ip eq $local_ip) ) { $local=1; }
my $credentials = $opts{c};
if ($opts{v}) { $VERBOSE=1; }
if ($opts{a}) { $pattern=$opts{a}; }

#--------------------------------------------------------------------
# VECTOR CON LOS COMANDOS A EJECUTAR EN REMOTO
#--------------------------------------------------------------------
my @CMDS=( "/usr/bin/dpkg -al|/bin/grep '^ii'|grep $pattern" );
#--------------------------------------------------------------------
#--------------------------------------------------------------------


#--------------------------------------------------------------------
#--------------------------------------------------------------------
my ($stdout, $stderr, $exit) = ('', '', 0);
my $ssh;
my $t0 = [gettimeofday];
my $elapsed=0;
my $remote;


$SIG{CHLD} = 'IGNORE';


if (! $local) { 
   $remote = CNMScripts::Telnet->new( 'host'=>$ip, 'credentials'=>$credentials );
	$remote->connect();
	if ($remote->err_num()==0) {
	   ($stdout, $stderr) = $remote->cmd(\@CMDS);
		foreach my $cmd (@CMDS) {
   		print $stdout->{$cmd}->{'stdout'}."\n";
		}
	}
	else { die $remote->err_str()."\n"; }
}

else { 
	foreach my $cmd (@CMDS) {
		my $result = `$cmd`;
		print $result;
	}
}


#--------------------------------------------------------------------
#--------------------------------------------------------------------
# FUNCIONES AUXILIARES
#--------------------------------------------------------------------
#--------------------------------------------------------------------
sub my_ip {

   my $r=`/sbin/ifconfig eth0`;
   $r=~/inet\s+addr\:(\d+\.\d+\.\d+\.\d+)\s+/;
   return $1;
}

#--------------------------------------------------------------------
sub verbose {
my ($msg)=@_;

	if ($VERBOSE) {print STDERR "$msg\n"; }
}

