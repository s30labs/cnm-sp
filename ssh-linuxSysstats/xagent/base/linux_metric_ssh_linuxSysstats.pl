#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME:  linux_metric_ssh_linuxSysstats.pl
# AUTHOR: Fernando Marin <fmarin\@s30labs.com>
# DATE: 27/01/2015
# VERSION: 1.0
#
# DESCRIPTION:
# Obtiene metricas de SO en un host remoto LINUX mediante una conexion  SSH 
#
# USAGE:
# linux_metric_ssh_linuxSysstats.pl -n 1.1.1.1 [-port 2322]
# linux_metric_ssh_linuxSysstats.pl -n 1.1.1.1 -user=aaa -pwd=bbb
# linux_metric_ssh_linuxSysstats.pl -n 1.1.1.1 -user=aaa -key_file=/etc/ssh/id_rsa
# linux_metric_ssh_linuxSysstats.pl -n 1.1.1.1 -user=aaa -key_file=1
# linux_metric_ssh_linuxSysstats.pl -h  : Ayuda
#
# -n          : IP remota
# -port       : Puerto
# -user       : Usuario
# -pwd	     : Clave
# -passphrase : Passphrase SSH
# -key_file   : Fichero con la clave publica (Si vale 1 indica que ua el ficheo estandar de CNM)
# -v/-verbose : Muestra informacion extra(debug)
# -h/-help    : Ayuda
# -l          : Lista las metricas que obtiene 
#
# </CNMDOCU>
#--------------------------------------------------------------------
MYHEADER
};
use lib '/opt/crawler/bin/';
use strict;
use warnings;
use Getopt::Long;
use CNMScripts;
use CNMScripts::SSH;
use Data::Dumper;

#--------------------------------------------------------------------
#--------------------------------------------------------------------
# https://www.kernel.org/doc/Documentation/filesystems/proc.txt
my %CMDS = (
   '001_diskstats' => "/usr/bin/sar -dp | tail -n 30",
);

my %PARSERS = (

   '001_diskstats' => \&diskstats,
);

#--------------------------------------------------------------------
my $script = CNMScripts::SSH->new();
my %opts = ();
my $ok=GetOptions (\%opts,  'h','help','v','verbose','l','user=s','pwd=s','port=s','n=s','key_file=s','passphrase=s');
if (! $ok) {
	print STDERR "***ERROR EN EL PASO DE PARAMETROS***\n";	
	$script->usage($main::MYHEADER); 
	exit 1;
}

my $LIST_METRICS=0;
if (defined $opts{'l'}) {
	$LIST_METRICS=1;
	foreach my $tag (sort keys %CMDS) {
		&{$PARSERS{$tag}}($script, '', '');
	}		
	exit 0;
}

my $VERBOSE = ((defined $opts{'v'}) || (defined $opts{'verbose'})) ? 1 : 0;

if ( ($opts{'h'}) || ($opts{'help'})) { $script->usage($main::MYHEADER); }

my $ip = ($opts{'n'}) ? $opts{'n'} : $script->usage($main::MYHEADER);
$script->host($ip);

my $port = ((defined $opts{'port'}) && ($opts{'port'})=~/\d+/) ? $opts{'port'} : 22;
$script->port($port);

my %credentials=();
if ($opts{'user'}) { $credentials{'user'}=$opts{'user'}; }
if ($opts{'pwd'}) { $credentials{'password'}=$opts{'pwd'}; }
if ($opts{'key_file'}) { $credentials{'key_file'}=$opts{'key_file'}; }
if ($opts{'passphrase'}) { $credentials{'passphrase'}=$opts{'passphrase'}; }
$script->credentials(\%credentials);

if ($VERBOSE) { print "CREDENCIALES\n",Dumper(\%credentials), "\n"; }

#--------------------------------------------------------------------
#--------------------------------------------------------------------
if (! $script->is_local($ip)) { 
	$script->connect();
	if ($script->err_num()!=0) {
		print STDERR "***ERROR EN CONEXION A $ip*** [".$script->err_str()."]\n";	
		exit 2;
	}

   my $results = $script->cmd(\%CMDS);
	foreach my $tag (sort keys %$results) {
      if (! exists $PARSERS{$tag}) {
         print STDERR "***NO DEFINIDO PARSER ASOCIADO A $tag***\n";
         exit 3;
      }

		&{$PARSERS{$tag}}($script, $results->{$tag}->{'stdout'}, $results->{$tag}->{'stderr'});
	}
}

else { 
	my $script_local = CNMScripts->new();
	my $results = $script_local->cmd(\%CMDS);
   foreach my $tag (sort keys %$results) {
      if (! exists $PARSERS{$tag}) {
         print STDERR "***NO DEFINIDO PARSER ASOCIADO A $tag***\n";
         exit 3;
      }
      &{$PARSERS{$tag}}($script, $results->{$tag}->{'stdout'}, $results->{$tag}->{'stderr'});
   }
}

$script->print_metric_data();

exit 0;

#--------------------------------------------------------------------
#--------------------------------------------------------------------
# FUNCIONES AUXILIARES
#--------------------------------------------------------------------

#--------------------------------------------------------------------
# 00:00:01          DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
# 00:01:02          vda    295.59    105.65  28879.21     98.06    112.67    343.49      3.34     98.70
#--------------------------------------------------------------------
sub diskstats {
my ($script,$stdout, $stderr) = @_;

	my %TAGS=( '001'=>'tps', '002'=>'rd_secs', '003'=>'wr_secs', '004'=>'avgrq_sz', '005'=>'avgqu_sz', '006'=>'await', '007'=>'svctm', '008'=>'perc_util',);
	if ($LIST_METRICS) { 
		foreach my $tag (sort keys %TAGS) { print "<$tag>\t$TAGS{$tag}\n"; }
		return;
	}

   if ($stderr ne '') {
		foreach my $tag (sort keys %TAGS) { $script->test_init($tag,$TAGS{$tag}); }
		foreach my $tag (sort keys %TAGS) { $script->test_done($tag,'U'); }
      return;
   }

   my $last_date='';
	my $nzombies=0;
   my @lines = split (/\n/, $stdout);
   foreach my $l (@lines) {
      chomp;
		my @d=split(/\s+/,$l);
		if (scalar(@d)<8) { next; }
		if ($d[0]=~/\d+\:\d+\:\d+/) { $last_date = $d[0]; }
	}

	my @tag_vals = sort keys %TAGS;
   foreach my $l (@lines) {
      chomp;
		#my ($date,$dev,$tps,$rd_secs,$wr_secs,$avgrq_sz,$avgqu_sz,$await,$svctm,$perc_util) = split(/\s+/,$l);
		my @d=split(/\s+/,$l);	
		if ($d[0] ne $last_date) { next;}

		my $iid = $d[1];
		my $j=0;
		foreach my $i (2..scalar(@d)-1) {
			my $tag_iid = $tag_vals[$j].'.'.$iid;
			my $value =$d[$i];
			$script->test_init($tag_iid,$TAGS{$tag_vals[$j]});
			$script->test_done($tag_iid,$value);
			$j +=1;
		}
   }
}

