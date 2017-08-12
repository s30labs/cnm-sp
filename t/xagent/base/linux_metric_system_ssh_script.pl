#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME:  linux_metric_system_ssh_script.pl
# AUTHOR: s30labs
# DATE: 27/01/2015
# VERSION: 1.0
#
# DESCRIPTION:
# Ejecuta un script en un host remoto mediante SSH 
#
# USAGE:
# linux_metric_system_ssh_script.pl -n localhost [-a pattern] [-v]
# linux_metric_system_ssh_script.pl -n 1.1.1.1 -c "-user=aaa -pwd=bbb" [-a pattern] [-v]
# linux_metric_system_ssh_script.pl -h  : Ayuda
#
# INPUT (PARAMS):
# -n  :  IP remota
# -c  :  Credenciales
#
# </CNMDOCU>
#--------------------------------------------------------------------
MYHEADER
};
use lib '/opt/crawler/bin/';
use strict;
use warnings;
use Getopt::Std;
use CNMScripts;
use CNMScripts::SSH;
use Data::Dumper;

#--------------------------------------------------------------------
#--------------------------------------------------------------------
my $script = CNMScripts::SSH->new();
my %opts=();
getopts("hn:c:",\%opts);
if ($opts{h}) { $script->usage($main::MYHEADER); }
my $ip = ($opts{n}) ? $opts{n} : $script->usage($main::MYHEADER);
my $credentials = $opts{c};

#$fpth[$#fpth] -n localhost -a pattern [-v]
#$fpth[$#fpth] -n IP -a pattern -c "-user=aaa -pwd=bbb" [-v]
#$fpth[$#fpth] -h  : Ayuda
#
#-n		IP remota/local
#-c		Credenciales SSH
#-a 	Patron de busqueda
#-v		Verbose

#--------------------------------------------------------------------
#--------------------------------------------------------------------
# VECTOR CON LOS COMANDOS A EJECUTAR EN REMOTO
#--------------------------------------------------------------------
my %CMDS = ( 
#	'<001> Zombie Processes' => "/bin/ps -eo state | /bin/grep -c Z",
#	'<002> Uptime' => "/usr/bin/awk '{print \$1}' /proc/uptime",

	'cmd_001' => "/bin/ps -eo state | /bin/grep -c Z",
	'cmd_002' => "/usr/bin/awk '{print \$1}' /proc/uptime",
	'cmd_003' => '/usr/bin/lsof',

#/usr/bin/lsof | perl -lane '\$x{"\$F[0]:\$F[1]"}++; END { print "\$x{\$_}\t\$_\" for sort {\$x{\$a}<=>\$x{\$b}} keys \%x}',
);

my %PARSERS = (

   'cmd_001' => &cmd_001, 
   'cmd_002' => &cmd_002,
   'cmd_003' => &cmd_003,

#/usr/bin/lsof | perl -lane '\$x{"\$F[0]:\$F[1]"}++; END { print "\$x{\$_}\t\$_\" for sort {\$x{\$a}<=>\$x{\$b}} keys \%x}',
);

#--------------------------------------------------------------------
#--------------------------------------------------------------------


#--------------------------------------------------------------------
#--------------------------------------------------------------------
my ($stdout, $stderr, $exit) = ('', '', 0);
#my $remote;

$SIG{CHLD} = 'IGNORE';

$script->host($ip);

if (! $script->is_local($ip)) { 
	$script->connect();
	if ($script->err_num()==0) {
	   my $results = $script->cmd(\%CMDS);

print Dumper($results);
&$PARSERS{$tag};
next;

		foreach my $tag (sort keys %$results) {

			if ($results->{$tag}->{'stderr'} eq '') {
				print $tag.' = '.$results->{$tag}->{'stdout'}."\n";
			}
			else {
				print $tag.' = U';
			}
		}
	}
}

else { 
	foreach my $tag (sort keys %CMDS) {
		my $cmd = $CMDS{$tag};
		my $result = `$cmd`;
		chomp $result;
		print $tag.' = '.$result."\n";
	}
}


#------------------
#$script->test_init('001','----DESCR_METRICA----');
# ----MI_CODIGO----
#$script->test_done('001',----RESULTADO----);

# Opción de escribir en /var/log/scripts.log
#$script->log('info',"host=$ip port=$port");
#
##-------------------
#$script->print_metric_data();


#--------------------------------------------------------------------
#--------------------------------------------------------------------
# FUNCIONES AUXILIARES
#--------------------------------------------------------------------
sub cmd_001 {

	print "cmd_001\n";
}

#--------------------------------------------------------------------
sub cmd_002 {

   print "cmd_002\n";
}

#--------------------------------------------------------------------
sub cmd_003 {

   print "cmd_003\n";
}

