#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME:  linux_metric_db_mssqlCmd.pl
# AUTHOR: Fernando Marin <fmarin\@s30labs.com>
# DATE: 27/01/2015
# VERSION: 1.0
#
# DESCRIPTION:
# Obtiene metricas de SO en un host remoto LINUX mediante una conexion  SSH 
#
# USAGE:
# linux_metric_db_mssqlCmd.pl -host 1.1.1.1 -db MYDATABASE -user user1 -pwd mysecret -sqlcmd "SET NOCOUNT ON;SELECT COUNT(xx) AS "001" FROM ttt FOR JSON AUTO" [-port 1433] [-tag 001] [-label "Number of users"]
 linux_metric_db_mssqlCmd.pl -h  : Help
#
# -host       : Database Server Host
# -port       : Port (default 1433)
# -user       : DB User
# -pwd	     : DB User Password
# -sqlcmd     : SQL Sentence
# -tag        : Tag associated with the metric
# -label      : Label associated with the metric
# -v/-verbose : Verbose output (debug)
# -h/-help    : Help
#
# </CNMDOCU>
#--------------------------------------------------------------------
MYHEADER
};
use lib '/opt/crawler/bin/';
use strict;
use warnings;
use Getopt::Long;
use CNMScripts::MSSQL;
use JSON;
use Data::Dumper;

#--------------------------------------------------------------------
#--------------------------------------------------------------------
my $script = CNMScripts::MSSQL->new();
my %opts = ();
my $ok=GetOptions (\%opts,  'h','help','v','verbose','user=s','pwd=s','port=s','host=s', 'db=s', 'sqlcmd=s', 'tag=s', 'label=s');
if (! $ok) {
	print STDERR "***ERROR EN EL PASO DE PARAMETROS***\n";	
	$script->usage($main::MYHEADER); 
	exit 1;
}

#my $LIST_METRICS=0;
#if (defined $opts{'l'}) {
#	$LIST_METRICS=1;
#	foreach my $tag (sort keys %CMDS) {
#		&{$PARSERS{$tag}}($script, '', '');
#	}		
#	exit 0;
#}

my $VERBOSE = ((defined $opts{'v'}) || (defined $opts{'verbose'})) ? 1 : 0;

if ( ($opts{'h'}) || ($opts{'help'})) { $script->usage($main::MYHEADER); }

my $ip = ($opts{'host'}) ? $opts{'host'} : $script->usage($main::MYHEADER);
$script->host($ip);

my $sqlcmd = ($opts{'sqlcmd'}) ? $opts{'sqlcmd'} : $script->usage($main::MYHEADER);
$script->sqlcmd($sqlcmd);

my $port = ((defined $opts{'port'}) && ($opts{'port'})=~/\d+/) ? $opts{'port'} : 1433;
$script->port($port);

my $user = (defined $opts{'user'}) ? $opts{'user'} : '';
$script->user($user);
my $pwd = (defined $opts{'pwd'}) ? $opts{'pwd'} : '';
$script->pwd($pwd);
my $db = (defined $opts{'db'}) ? $opts{'db'} : '';
$script->db($db);
 
if ($VERBOSE) { 
	print "PARAMETERS *****\n";
	print Dumper (\%opts);
	print "ip=$ip port=$port user=$user pwd=$pwd sqlcmd=$sqlcmd\n"; 
	print "*****\n";
}

#--------------------------------------------------------------------
my $data = $script->sqlcmd_run($sqlcmd, {'json'=>1});

if ($VERBOSE) {
	print Dumper($data);
}

my $tag = (defined $opts{'tag'}) ? $opts{'tag'} : '001';
my $label = (defined $opts{'label'}) ? $opts{'label'} : 'Metrica1';
foreach my $kv (@$data) { 
	if ((exists $kv->{$tag}) && ($kv->{$tag}=~/\d+/)) { 
		$script->test_init($tag,$label);
		$script->test_done($tag,$kv->{$tag});
	}
}

$script->print_metric_data();

exit 0;

