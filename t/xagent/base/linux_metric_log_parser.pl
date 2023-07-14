#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_metric_log_parser.pl
#
# DESCRIPTION:
# Obtiene metricas de estado a partir de las lineas del fichero de log del Servidor WEB Apache especificado.
#
# CALLING SAMPLE:
# linux_metric_log_parser.pl -n 1.1.1.1 [-f access.log]
#
# INPUT (PARAMS):
# a. -n  :  IP remota
#
# OUTPUT (STDOUT):
#<001> Parents = 0
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
use Time::Local;
use Data::Dumper;
use CNMScripts::SSH;

#-------------------------------------------------------------------------------------------
my %LINE_PARSERS = (

	'std' => \&parser001,

);

#-------------------------------------------------------------------------------------------
my %opts=();
my $USAGE="Uso: $0 -n ip [-a connect_mode ssh|nfs|cifs] [-c credentials] [-m mode] [-f file] [-p pattern] [-l lapse]";
# -user=aaaa -pwd=bbb 

getopts("hm:n:f:p:l:a:c:",\%opts);

#-------------------------------------------------------------------------------------------
if (exists $opts{h}) { die "$USAGE\n"; }

if (! exists $opts{n}) { die "$USAGE\n"; }
my $local_ip = my_ip();
my $ip = $opts{n};
my $local = 0;
if ( ($ip eq 'localhost') || ($ip eq '127.0.0.1') || ($ip eq $local_ip) ) { $local=1; }

my $line_parser = (exists $opts{m}) ? $LINE_PARSERS{$opts{m}} :$LINE_PARSERS{'std'};
my $file = (exists $opts{f}) ? $opts{f} : '/var/log/messages';
my $pattern = (exists $opts{p}) ? $opts{p} : '';

my $credentials = (exists $opts{c}) ? $opts{c} : '';
my $lapse = (exists $opts{l}) ? $opts{l} : 300;	#300 segs = 5 min
my $limit = time() - $lapse;

#-------------------------------------------------------------------------------------------
my $script = '/opt/crawler/bin/libexec/linux_log_parser.pl';

#-------------------------------------------------------------------------------------------
if (! $local) {
   my $remote = CNMScripts::SSH->new( 'host'=>$ip, 'credentials'=>$credentials );
   ($stdout, $stderr) = $remote->execute($script);
}
else {
   $stdout = `perl $script`;
}

my @lines=split(/\n/,$stdout);
my $nlines=0;
foreach my $l (@lines) {
	chomp $l;
	print "$l\n";
	$nlines+=1;
}

print '<001> Lineas = '.$nlines."\n";

#--------------------------------------------------------------------------------------
sub my_ip {

   my $r=`/sbin/ifconfig eth0`;
   if ($r=~/inet\s+addr\:(\d+\.\d+\.\d+\.\d+)\s+/) { return $1; }
   elsif ($r=~/inet\s+(\d+\.\d+\.\d+\.\d+)\s+/) { return $1; }
   return '';
}


#-------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------
__DATA__
use Time::Local;

my @lines = `grep -n "" /var/log/messages | sort -r -n | sed 's/^[0-9]*://g'`;
my $limit=time-300;
foreach my $l (@lines) {

   chomp;
   my ($tline,$txt) = parser001($l);
   if ($tline<$limit) { last;}

#print "pattern=$pattern\n";
   if (($pattern ne '') && ($txt !~ /$pattern/)) { next;}

   #print $tline .'::'. $l ."\n";
	print $l;
}

#print '<001> Lineas = '.$nlines."\n";
unlink $0;

#--------------------
sub parser001 {
my $line=shift;

   my ($mday,$mon,$year,$hour,$min,$sec,$extra_line)=('','','','','','','');
   my %months=( 'Jan'=>0, 'Feb'=>1);
   my $timestamp = 0;
   my @now=localtime(time);
   if ($line =~ /^(\w{3})\s+(\d+)\s+(\d+)\:(\d+)\:(\d+)\s+(.*)$/) {
      ($mday,$mon,$year,$hour,$min,$sec,$extra_line)=($2,$1,$now[5],$3,$4,$5,$6);
      $timestamp = timelocal($sec,$min,$hour,$mday,$months{$mon},$year);
   }
   return ($timestamp, $extra_line);
}

