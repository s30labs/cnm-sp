#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_app_ssh_syslog.pl
#
# DESCRIPTION:
# Ejecuta un script en un host remoto mediante SSH 
#
# CALLING SAMPLE:
# linux_app_ssh_syslog.pl -n 1.1.1.1 -d /opt [-a pattern] [-v]
# linux_app_ssh_syslog.pl -n 1.1.1.1 -u user -p pwd -d /opt [-a pattern] [-v]
# linux_app_ssh_syslog.pl -n 1.1.1.1 -u user -k -p passphrase -d /opt [-a pattern] [-v]
# linux_app_ssh_syslog.pl -h  : Ayuda
#
# INPUT (PARAMS):
# -n  :  IP remota
# -c  :  Credencial CNM 
# -u	:	Usa autenticacion por clave publica
# -p  :  Clave|Passphrase (ssh)
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
use CNMScripts;
use CNMScripts::SSH;
use CNMScripts::SyslogRaw;
use Stdout;
use Time::HiRes qw(gettimeofday tv_interval);

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $VERSION="1.0";

my $USAGE = <<USAGE;
linux_app_ssh_syslog.pl $VERSION

$fpth[$#fpth] -n IP -c nombre_credencial 
$fpth[$#fpth] -n IP -c '-user=aaa -pwd=bbb' [-w xml] [-v]
$fpth[$#fpth] -h  : Ayuda

-n  IP remota/local
-c  Credenciales SSH
-x  Comando a ejecutar. Si hay varios, se pueden separar con &&.
-i  Utiliza modo interactivo.
-p  Prompt (necesario si es modo interactivo)
-l  Se genera la salida para el syslog linea a linea. En caso contrario el resultado del comando se mete en una linea de syslog.
-w  Formato de salida (xml|txt)
-h  Ayuda
USAGE

#--------------------------------------------------------------------------------------
my $local_ip = 'localhost';
my $r=`/sbin/ifconfig eth0`;
if ($r=~/inet\s+addr\:(\d+\.\d+\.\d+\.\d+)\s+/) { $local_ip = $1; }


my $local=0;
my ($PK,$dir,$pattern,$FORMAT)=(undef,'','.','json');

#--------------------------------------------------------------------------------------
my %opts=();
getopts("hlin:c:w:x:p:",\%opts);

if ($opts{h}) { die $USAGE;}
my $ip=$opts{n} || die $USAGE;
#my $credentials = $opts{c} || die $USAGE;
my $credentials = $opts{c} || '';
my $pcmds = $opts{x} || die $USAGE;
my @CMDS = split('&&',$pcmds);

my $mode = (exists $opts{i}) ? 'interactive' : 'default'; 
my $prompt = (exists $opts{p}) ? $opts{p} : '';

my $ML=0;
if ($opts{l}) { $ML=1; }

if ( ($ip eq 'localhost') || ($ip eq '127.0.0.1') || ($ip eq $local_ip) ) { $local=1; }

if ((exists $opts{w}) && ($opts{w}=~/txt/i)) { $FORMAT='txt'; }

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
my ($host,$stdout, $stderr, $exit,$results) = (undef,'', '', 0, {});

$SIG{CHLD} = 'IGNORE';
my $timeout=30;

if (! $local) { 
  	$host = CNMScripts::SSH->new( 'host'=>$ip, 'credentials'=>$credentials, 'mode'=>$mode, 'prompt'=>$prompt );
   $host->connect();
   if ($host->err_num()==0) {
      $results = $host->cmd(\@CMDS);
   }
	else { 
      $results->{'connect'}->{'stdout'} = '';
      $results->{'connect'}->{'stderr'} = "**ERROR** ($!) ".$host->err_str();
		$host->print_app_data($ip,$results,$FORMAT);
		exit;
	}
}

else { 
   $host = CNMScripts->new();
   if ($host->err_num()==0) {
      $results = $host->cmd(\@CMDS);
   }
	else {
      $results->{'connect'}->{'stdout'} = '';
      $results->{'connect'}->{'stderr'} = "**ERROR** ($!) ".$host->err_str();
		$host->print_app_data($ip,$results,$FORMAT);
		exit;
   }
}

my $pname=$0;
$pname=~s/^.+\/(\S+?)$/$1/;
my $syslog_raw = CNMScripts::SyslogRaw->new('src_ip'=>$ip, 'dst_ip'=>'localhost', 'facility'=>'local2', 'pname'=>$pname);

if ($ML) { $syslog_raw->app_data2syslog_ml($results); }
else { $syslog_raw->app_data2syslog($results); }

$host->print_app_data($ip,$results,$FORMAT);


