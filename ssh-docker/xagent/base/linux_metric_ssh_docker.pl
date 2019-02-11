#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME:  linux_metric_ssh_docker.pl
# AUTHOR: Fernando Marin <fmarin\@s30labs.com>
# DATE: 27/01/2015
# VERSION: 1.0
#
# DESCRIPTION:
# Obtiene metricas de SO en un host remoto LINUX mediante una conexion  SSH 
#
# USAGE:
# linux_metric_ssh_docker.pl -n 1.1.1.1 [-port 2322]
# linux_metric_ssh_docker.pl -n 1.1.1.1 -user=aaa -pwd=bbb
# linux_metric_ssh_docker.pl -n 1.1.1.1 -user=aaa -key_file=/etc/ssh/id_rsa
# linux_metric_ssh_docker.pl -n 1.1.1.1 -user=aaa -key_file=1
# linux_metric_ssh_docker.pl -h  : Ayuda
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
   '001_docker_ps_a' => "docker ps -a",
);

my %PARSERS = (

   '001_docker_ps_a' => \&docker_ps_a,
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
# docker ps -a
# CONTAINER ID        IMAGE                   COMMAND                  CREATED             STATUS                PORTS               NAMES
# 9d53da180b5b        saphana                 "bash -c /mnt/sql/27…"   14 minutes ago      Up 16 seconds                       vigilant_saha
# a37a024f91b3        saphana                 "bash -c /mnt/sql/66…"   About an hour ago   Removal In Progress                   goofy_gates

sub docker_ps_a {
my ($script,$stdout, $stderr) = @_;

	my %TAGS=( '001'=>'Running Containers', '002'=>'RIP Containers', '003'=>'Other Containers' );
   if ($LIST_METRICS) {
      foreach my $tag (sort keys %TAGS) { print "<$tag>\t$TAGS{$tag}\n"; }
      return;
   }

   $script->test_init('001',$TAGS{'001'});
   $script->test_init('002',$TAGS{'002'});
   $script->test_init('003',$TAGS{'003'});
   if ($stderr ne '') {
      $script->test_done('001','U');
      $script->test_done('002','U');
      $script->test_done('003','U');
      return;
   }

   my ($running,$rip,$other)=(0,0,0);
   my @lines = split (/\n/, $stdout);
   foreach my $l (@lines) {
      chomp $l;
      if ($l=~/Removal In Progress/i) { $rip+=1; }
		elsif (($l=~/Up /i)||($l=~/Created /i)) { $running+=1; }
		else { $other+=1; }
	}

   $script->test_done('001',$running);
   $script->test_done('002',$rip);
   $script->test_done('003',$other);

}

