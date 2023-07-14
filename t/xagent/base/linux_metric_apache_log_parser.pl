#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:  linux_metric_apache_log_parser.pl
#
# DESCRIPTION:
# Obtiene metricas de estado a partir de las lineas del fichero de log del Servidor WEB Apache especificado.
#
# CALLING SAMPLE:
# linux_metric_apache_log_parser.pl -n 1.1.1.1 [-f access.log]
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
use CNMScripts::SSH;
use Data::Dumper;

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
my $lapse = (exists $opts{l}) ? $opts{l} : 300; #300 segs = 5 min
my $limit = time() - $lapse;


#-------------------------------------------------------------------------------------------
my $script = '/tmp/'.int (1000000000*rand()).'.pl';
open (F,">$script");
while (<DATA>) { print F $_; }
close F;

#-------------------------------------------------------------------------------------------
if (! $local) {
   my $remote = CNMScripts::SSH->new( 'host'=>$ip, 'credentials'=>$credentials );
   ($stdout, $stderr) = $remote->execute($script);
}
else {
   $stdout = `perl $script`;
}

unlink $script;
#chomp $stdout;
#print $stdout."\n";
my %CODES=();
my $nlines=0;
my @lines=split(/\n/,$stdout);
foreach my $l (@lines) {
	chomp $l;
	my $info_line=parser_ncsa($l);
	$nlines+=1;

   if (! exists $CODES{$info_line->{'code'}}) { $CODES{$info_line->{'code'}} = 1; }
   else {$CODES{$info_line->{'code'}} += 1; }

	print "$l\n";
}


print Dumper(\%CODES);


#--------------------------------------------------------------------------------------
sub my_ip {

   my $r=`/sbin/ifconfig eth0`;
   if ($r=~/inet\s+addr\:(\d+\.\d+\.\d+\.\d+)\s+/) { return $1; }
   elsif ($r=~/inet\s+(\d+\.\d+\.\d+\.\d+)\s+/) { return $1; }
   return '';
}

#-------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------
sub parser_ncsa {
my $line=shift;

   my ($ip,$ident,$user,$date,$request,$status,$size,$other,$ua);
   my ($mday,$mon,$year,$hour,$min,$sec,$extra_line)=('','','','','','','');
   my %months=( 'Jan'=>0, 'Feb'=>1);
   my $timestamp = 0;
   my @now=localtime(time);
   if ($line =~ /^(\S+)\s+(\S+)\s+(\S+)\s+\[(.*?)\]\s+\"(.*?)\"\s+(\S+)\s+(\S+)\s+(\S+)\s+\"(.*)\"$/) {

      ($ip,$ident,$user,$date,$request,$status,$size,$other,$ua)=($1,$2,$3,$4,$5,$6,$7,$8,$9);

      print "date=$date request=$request status=$status size=$size ua=$ua\n";
      if ($date =~ /(\d+)\/(\S+)\/(\d+)\:(\d+)\:(\d+)/) {
         ($mday,$mon,$year,$hour,$min,$sec)=($1,$2,$3,$4,$5,$6);
         if ($mon =~ /\d+/) { $mon-=1; }
         elsif (exists $months{$mon}) { $mon=$months{$mon}; }

         $timestamp = timelocal($sec,$min,$hour,$mday,$mon,$year-1900);
      }
   }
   return ( {'timestamp'=>$timestamp, 'date'=>$date, 'user'=>$user, 'ident'=>$ident, 'ip'=>$ip, 'request'=>$request, 'status'=>$status, 'size'=>$size, 'ua'=>$ua} );
}

#-------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------
__DATA__
use Time::Local;

my @lines = `grep -n "" /var/log/apache2/access.log | sort -r -n | sed 's/^[0-9]*://g'`;
my $limit=time-300;
foreach my $l (@lines) {

   chomp;
   my $info_line = parser_ncsa($l);
   if ($info_line->{'timestamp'} < $limit) { last;}

print $info_line->{'timestamp'}.'---->'.$limit."\n";
#print "pattern=$pattern\n";
   if (($pattern ne '') && ($txt !~ /$pattern/)) { next;}

   #print $tline .'::'. $l ."\n";
   print $l;
}

#unlink $0;

#10.2.254.222 - - [15/Feb/2013:09:41:05 +0100] "POST /cnmws/CNMConfigServices.php HTTP/1.1" 200 282 "-" "SOAP::Lite/Perl/0.714"
#--------------------
sub parser_ncsa {
my $line=shift;

	my ($ip,$ident,$user,$date,$request,$status,$size,$other,$ua);
   my ($mday,$mon,$year,$hour,$min,$sec,$extra_line)=('','','','','','','');
   my %months=( 'Jan'=>0, 'Feb'=>1);
   my $timestamp = 0;
   my @now=localtime(time);
   if ($line =~ /^(\S+)\s+(\S+)\s+(\S+)\s+\[(.*?)\]\s+\"(.*?)\"\s+(\S+)\s+(\S+)\s+(\S+)\s+\"(.*)\"$/) {

      ($ip,$ident,$user,$date,$request,$status,$size,$other,$ua)=($1,$2,$3,$4,$5,$6,$7,$8,$9);

      #print "date=$date request=$request status=$status size=$size ua=$ua\n";
      if ($date =~ /(\d+)\/(\S+)\/(\d+)\:(\d+)\:(\d+)/) {
         ($mday,$mon,$year,$hour,$min,$sec)=($1,$2,$3,$4,$5,$6);
         if ($mon =~ /\d+/) { $mon-=1; }
         elsif (exists $months{$mon}) { $mon=$months{$mon}; }

         $timestamp = timelocal($sec,$min,$hour,$mday,$mon,$year-1900);
      }
   }
   return ( {'timestamp'=>$timestamp, 'date'=>$date, 'user'=>$user, 'ident'=>$ident, 'ip'=>$ip, 'request'=>$request, 'status'=>$status, 'size'=>$size, 'ua'=>$ua} );
}
