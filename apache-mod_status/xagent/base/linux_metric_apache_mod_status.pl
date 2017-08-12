#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  metric_apache_mod_status.pl
#
# DESCRIPTION:
# Obtiene metricas a del Servidor WEB Apache a partir del modulo mod_status.
#
# CALLING SAMPLE:
# metric_apache_mod_status.pl -n 1.1.1.1
#
# INPUT (PARAMS):
# a. -n  :  IP remota
#
# OUTPUT (STDOUT):
#<001> Parents = 0
#<002> Requests = 1
#<003> Idle workers = 5
#<004> Waiting for Connection = 5
#<005> Starting up = 0
#<006> Reading Request = 0
#<007> Sending Reply = 1
#<008> Keepalive (read) = 0
#<009> DNS Lookup = 0
#<010> Closing connection = 0
#<011> Logging = 0
#<012> Gracefully finishing = 0
#<013> Idle cleanup of worker = 0
#<014> Open slot with no current process = 250
#<015> Total accesses = 2503
#<016> Total traffic = 433 kB
#<017> Requests per second = .0295
#<018> Bytes per second = 5
#<019> Bytes per request = 177

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
use Parse::Apache::ServerStatus;
use Data::Dumper;

#-------------------------------------------------------------------------------------------
my %opts=();
my $USAGE="Uso: $0 -n ip [-s]";
getopts("hsn:",\%opts);

#-------------------------------------------------------------------------------------------
if (exists $opts{h}) { die "$USAGE\n"; }
if (! exists $opts{n}) { die "$USAGE\n"; }

#-------------------------------------------------------------------------------------------
my $URI='http:';
if ($opts{s}) { $URI='https:'; }
my $URL=$URI.'//'.$opts{n}.'/server-status';

   $|++;
   my $prs = Parse::Apache::ServerStatus->new( url =>$URL, timeout => 5);

	my $stat = $prs->get();
	if (! defined $stat) {
		print STDERR "ERROR: SIN RESPUESTA de server-status (url=$URL)\n";
		$stat = {'p'=>'U', 'r'=>'U', 'i'=>'U', '_'=>'U', 'S'=>'U', 'R'=>'U', 'W'=>'U', 'K'=>'U', 'D'=>'U', 'C'=>'U', 'L'=>'U', 'G'=>'U', 'I'=>'U', '.'=>'U', 'ta'=>'U', 'tt'=>'U', 'rs'=>'U', 'bs'=>'U', 'br'=>'U'};
	}

#	  p    Parents (this key will be kicked in future releases, dont use it)
#    r    Requests currenty being processed
#    i    Idle workers
#    _    Waiting for Connection
#    S    Starting up
#    R    Reading Request
#    W    Sending Reply
#    K    Keepalive (read)
#    D    DNS Lookup
#    C    Closing connection
#    L    Logging
#    G    Gracefully finishing
#    I    Idle cleanup of worker
#    .    Open slot with no current process
#
#    The following keys are set to 0 if extended server-status is not activated.
#
#    ta   Total accesses
#    tt   Total traffic
#    rs   Requests per second
#    bs   Bytes per second
#    br   Bytes per request

	if (exists $stat->{'p'}) {
		print '<001> Parents = '.$stat->{'p'}."\n";
	}
	if (exists $stat->{'r'}) {
		print '<002> Requests = '.$stat->{'r'}."\n";
	}
	if (exists $stat->{'i'}) {
		print '<003> Idle workers = '.$stat->{'i'}."\n";
	}
	if (exists $stat->{'_'}) {
		print '<004> Waiting for Connection = '.$stat->{'_'}."\n";
	}
	if (exists $stat->{'S'}) {
		print '<005> Starting up = '.$stat->{'S'}."\n";
	}
	if (exists $stat->{'R'}) {
		print '<006> Reading Request = '.$stat->{'R'}."\n";
	}
	if (exists $stat->{'W'}) {
		print '<007> Sending Reply = '.$stat->{'W'}."\n";
	}
	if (exists $stat->{'K'}) {
		print '<008> Keepalive (read) = '.$stat->{'K'}."\n";
	}
	if (exists $stat->{'D'}) {
		print '<009> DNS Lookup = '.$stat->{'D'}."\n";
	}
	if (exists $stat->{'C'}) {
		print '<010> Closing connection = '.$stat->{'C'}."\n";
	}
	if (exists $stat->{'L'}) {
		print '<011> Logging = '.$stat->{'L'}."\n";
	}
	if (exists $stat->{'G'}) {
		print '<012> Gracefully finishing = '.$stat->{'G'}."\n";
	}
	if (exists $stat->{'I'}) {
		print '<013> Idle cleanup of worker = '.$stat->{'I'}."\n";
	}
	if (exists $stat->{'.'}) {
		print '<014> Open slot with no current process = '.$stat->{'.'}."\n";
	}
	if (exists $stat->{'ta'}) {
		print '<015> Total accesses = '.$stat->{'ta'}."\n";
	}
	if (exists $stat->{'tt'}) {
		print '<016> Total traffic = '.$stat->{'tt'}."\n";
	}
	if (exists $stat->{'rs'}) {
		print '<017> Requests per second = '.$stat->{'rs'}."\n";
	}
	if (exists $stat->{'bs'}) {
		print '<018> Bytes per second = '.$stat->{'bs'}."\n";
	}
	if (exists $stat->{'br'}) {
		print '<019> Bytes per request = '.$stat->{'br'}."\n";
	}

