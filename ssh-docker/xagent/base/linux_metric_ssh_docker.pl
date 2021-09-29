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
   '002_docker_service_status' => "docker exec -it __CONTAINER__ bash -c 'service __SERVICE_NAME__ status'",
);

my %PARSERS = (

   '001_docker_ps_a' => \&docker_ps_a,
	'002_docker_service_status' => \&docker_service_status,
);

my %PARAMS = (

   '001_docker_ps_a' => [],
   '002_docker_service_status' => ['__CONTAINER__', '__SERVICE_NAME__'],
);

#--------------------------------------------------------------------
my $script = CNMScripts::SSH->new();
my %opts = ();
my $ok=GetOptions (\%opts,  'h','help','v','verbose','l','user=s','pwd=s','port=s','n=s','key_file=s','passphrase=s','params=s');
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

my %params = ();
if (defined $opts{'params'}) {
	my @pairs = split(';', $opts{'params'});
	foreach my $p (@pairs) {
		my ($k,$v) = split ('=', $p);
		$params{$k}=$v;
	}
	if ($VERBOSE) { print Dumper(\%params),"\n"; }
}
foreach my $k (keys %CMDS) {
	if (exists $params{'container'}) { my $x=$params{'container'}; $CMDS{$k}=~s/__CONTAINER__/$x/g; }
	if (exists $params{'service_name'}) { my $x=$params{'service_name'}; $CMDS{$k}=~s/__SERVICE_NAME__/$x/g; }
}

prepare_cmd();

if ($VERBOSE) { print Dumper(\%CMDS),"\n"; }
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
# Modifica los comandos que requieren parametros de entrada.
# 1. Si existen los parametros los sustituye.
# 2. Si no existen y el comando los necesita, elimina el comando de la ejecucion (el cmd y el parser).
#--------------------------------------------------------------------
sub prepare_cmd {

	my %opt_params = ();
	if (defined $opts{'params'}) {
   	my @pairs = split(';', $opts{'params'});
   	foreach my $p (@pairs) {
      	my ($k,$v) = split ('=', $p);
      	$opt_params{$k}=$v;
   	}
   	if ($VERBOSE) { print Dumper(\%opt_params),"\n"; }
	}
	foreach my $k (keys %PARAMS) {
		if (scalar(@{$PARAMS{$k}})==0) { next; }
		my $error=0;
		foreach my $p (@{$PARAMS{$k}}) {
			my $p1=$p;
			$p1=~s/__(\S+)__/$1/;
			my $p2 = lc $p1;
			if (exists $opt_params{$p2}) { 
				my $x=$opt_params{$p2};
				$CMDS{$k}=~s/$p/$x/g;
			}
			else { $error=1; last; }
		}
		if ($VERBOSE) { print "k=$k error=$error\n"; }
		if ($error) {
			delete $CMDS{$k};
			delete $PARSERS{$k};
		} 
	}
	if ($VERBOSE) { print Dumper(\%CMDS),"\n"; }

}

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

#--------------------------------------------------------------------
# docker service_status
# docker exec -it wwwavance bash -c "service apache2 status"
# [ ok ] apache2 is running.
# Returns: 0->ok, 1->error, 2->unk
#--------------------------------------------------------------------
sub docker_service_status {
my ($script,$stdout, $stderr) = @_;

   my %TAGS=( '004'=>'Service Status' );
	my $tag = join ('.', '004', $params{'service_name'});
	$TAGS{$tag} = join ('.', 'Service ', $params{'service_name'}, ' status');	
   if ($LIST_METRICS) {
      foreach my $tag (sort keys %TAGS) { print "<$tag>\t$TAGS{$tag}\n"; }
      return;
   }

   $script->test_init($tag,$TAGS{'001'});
   if ($stderr ne '') {
      $script->test_done($tag,'U');
      return;
   }

   my $status = 2;
   my @lines = split (/\n/, $stdout);
   foreach my $l (@lines) {
      chomp $l;
      if ($l=~/\[ok\]/i) { $status = 0; }
      elsif ($l=~/\[error\]/i) { $status = 1; }
   }

   $script->test_done($tag,$status);

}

