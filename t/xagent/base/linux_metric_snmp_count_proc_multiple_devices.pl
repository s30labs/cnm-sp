#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  snmp_metric_count_proc_multiple_devices
#
# DESCRIPTION:
# Obtiene la suma de procesos del nombre especificado en N dispositivos
#
# CALLING SAMPLE:
# snmp_metric_count_proc_multiple_devices -n 1.1.1.1 -r 1.1.1.2 -p apache2
# snmp_metric_count_proc_multiple_devices -n 1.1.1.1 -r 1.1.1.2,1.1.1.3 -p apache2
# nmp_metric_count_proc_multiple_devices-h  : Ayuda
#
# INPUT (PARAMS):
# a. -n  :  IP remota
# b. -r  :  resto de IPS remotas
# c. -p  :  Nombre del proceso
#
# OUTPUT (STDOUT):
# <001> Files opened [apache] = 1544
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
use Getopt::Std;
use ONMConfig;
use Crawler::SNMP;
use Crawler::Analysis;
use Stdout;
use JSON;

use Data::Dumper;
use Getopt::Std;

BEGIN { $ENV{'MIBS'}='HOST-RESOURCES-MIB'; }
#-------------------------------------------------------------------------------------------
my @RES=();
my %SNMPCFGCMD=();
my $FILE_CONF='/cfg/onm.conf';
my $rcfgbase=conf_base($FILE_CONF);
my $log_level='debug';
my $METRIC_TAG='001';

#-------------------------------------------------------------------------------------------
my %opts=();
my $USAGE="Uso: $0 -v version [-c comunity] [-u sec_name -l sec_level -a auth_proto -A auth_pass -x priv_proto -X priv_pass] -n host\nOpciones especiales: w->txt|html f->descriptor xml (mibt) o->oid z->last";
getopts("v:c:u:l:a:A:x:X:n:h:w:f:o:z:M:ir:r:",\%opts);

#-------------------------------------------------------------------------------------------
if (! exists $opts{n}) { die "$USAGE\n"; }

my @ips = ();
push @ips, $opts{n};
if (exists $opts{r}) { 
	my @pre_ips=split(',', $opts{r});
	foreach my $x (@pre_ips) {
		if ($x =~ /(\d+)\.(\d+)\.(\d+)\.(\d+)/) { push @ips, $x; } 
	}
}

my %proc_vector=();

foreach my $ip (@ips) {

	$opts{'n'}=$ip;
	%SNMPCFGCMD=();

	my $snmp=Crawler::SNMP->new(cfg=>$rcfgbase,log_level=>$log_level);
	my $rc=$snmp->get_command_options_ext(\%opts,\%SNMPCFGCMD);
	if (! defined $rc) { die "$USAGE\n"; }

	my $credentials=$snmp->get_snmp_credentials({'ip'=>$SNMPCFGCMD{'host_ip'}});
	my %SNMPCFG=(%SNMPCFGCMD, %$credentials);

	$SNMPCFG{oid}='hrSWRunName_hrSWRunPath_hrSWRunParameters';
	$SNMPCFG{last}='hrSWRunStatus';

	my $res=$snmp->core_snmp_table(\%SNMPCFG);

	#----------------------------------------------------------------------------
	if (!defined $res) {
   	print "NO SE HA OBTENIDO RESPUESTA A LA PETICION SOLICITADA\n";
   	my $error=$snmp->err_str();
   	print "**>$error\n";
		exit(1);
	}

	#----------------------------------------------------------------------------
	my @host_data=();

	for my $l ( @$res ) {

		if ($l eq 'U') { next; }
   	my ($id,$name,$path,$params)=split(':@:',$l);

		$name =~ s/^"(.*)"$/$1/;
		my $tag = $METRIC_TAG.'.'.$name;
		if (! exists $proc_vector{$tag}) { $proc_vector{$tag} = 1; }
		else { $proc_vector{$tag} += 1; }
	}
}

#-------------------------------------------------------------------------------------------
foreach my $tag (sort keys %proc_vector) {
	my ($t,$p) = split (/\./,$tag);
	print "<$tag> Num. procesos [$p] = $proc_vector{$tag}\n";
}

