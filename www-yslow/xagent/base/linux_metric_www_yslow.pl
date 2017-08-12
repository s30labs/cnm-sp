#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME:  linux_metric_www_perf.pl
# AUTHOR: Fernando Marin <fmarin\@s30labs.com>
# DATE: 27/01/2015
# VERSION: 1.0
#
# DESCRIPTION:
# Obtiene metricas de performance de una navegacion web.
#
# USAGE:
# linux_metric_www_perf.pl [-n 1.1.1.1] -u http://www.s30labs.com
# linux_metric_www_perf.pl -l  : List metrics
# linux_metric_www_perf.pl -h  : Ayuda
#
# -n          : IP remota
# -u          : URL
# -v/-verbose : Muestra informacion extra(debug)
# -h/-help    : Ayuda
# -l          : Lista las metricas que obtiene
#
# </CNMDOCU>
#--------------------------------------------------------------------
MYHEADER
};
use lib "/opt/crawler/bin";
use Getopt::Long;
use Data::Dumper;
use CNMScripts;
use CNMScripts::CNMAPI;
use JSON;
use File::Basename;
use Digest::MD5 qw(md5_hex);

# Parametros de entrada ---------------------------------------------
my %DESC=();
my @ALL_URLS=();
my $host_name='';
my $log_level='info';
my %OPTS = ();
GetOptions (\%OPTS,  'h','help','har','v','verbose','n=s','u=s','url=s','p=s','port=s','t=s','type=s','e=s','extra=s','page=s','l',
							'store_dir=s','iid=s',
                     'use_realm','realm_user=s','realm_pwd=s','id=s',
                     'use_proxy','proxy_user=s','proxy_pwd=s','proxy_host=s','proxy_port=s')
            or die "$0:[ERROR] en el paso de parametros. Si necesita ayuda ejecute $0 -help\n";

my $script=CNMScripts->new();

my $store_dir = $script->store_dir();
if ($store_dir !~ /\/$/) { $store_dir .=  '/'; }
my $script_tag = substr(md5_hex(basename($0)),0,6);

if ( ($OPTS{'help'}) || ($OPTS{'h'}) ) { 
   $script->usage($main::MYHEADER);
   exit 1;
}

elsif ($OPTS{'store_dir'}) {

   #if ( ((! exists $OPTS{'id'}) && (! exists $OPTS{'n'})) || (! exists $OPTS{'iid'}) ) {
   if (! exists $OPTS{'iid'}) {
      $script->usage($main::MYHEADER);
      exit 1;
   }

   my $host_ip = 'localhost';
   my $api=CNMScripts::CNMAPI->new( 'host'=>$host_ip, 'timeout'=>10, 'log_level'=>$log_level );
   my ($user,$pwd)=('admin','cnm123');
   my $sid = $api->ws_get_token($user,$pwd);

   my $class='devices';
   my $endpoint = $OPTS{'store_dir'}.'.json';

   #my $endpoint = (exists $OPTS{'n'}) ? $OPTS{'n'}.'.json' : $OPTS{'id'}.'.json';

   my $response = $api->ws_get($class,$endpoint,{});

   if ($response->[0]->{'name'} eq '') {
      print "**ERROR** SIN NOMBRE EN BBDD\n";
   }

   #$host_name = $response->[0]->{'name'};
   #if ($response->[0]->{'domain'} ne '') { $host_name .='.'.$response->[0]->{'domain'}; }
   #my $store_dir = $script->store_dir();

	$store_dir .= sprintf("%010d", $response->[0]->{'id'});

   #if ($store_dir !~ /\/$/) { $store_dir .=  '/'; }
   #$store_dir .= $script->set_store_id($host_name,$OPTS{'iid'});

   print $store_dir."\n";
	print $script_tag."\n";
   exit 0;

}

elsif (($OPTS{'u'}) || ($OPTS{'url'})) {

   if ($OPTS{'u'}) {  $DESC{'url'}=$OPTS{'u'}; }
   if ($OPTS{'url'}) { $DESC{'url'}=$OPTS{'url'}; }
   if ($DESC{'url'} =~ /^\d+\.\d+\.\d+\.\d+$/) { $DESC{'url'}="http://$DESC{'url'}";}
   if ($DESC{'url'} !~ /^http/) { $DESC{'url'}="http://DESC{'url'}";}
   push @ALL_URLS,$DESC{'url'};

}

elsif (($OPTS{'id'}) || ($OPTS{'n'})) {

#if (exists $OPTS{'ip'}) { $element=$OPTS{'ip'}; }

	#my $host_ip = (exists $OPTS{'n'}) ? $OPTS{'n'} : '';
	my $host_ip = 'localhost';

	my $api=CNMScripts::CNMAPI->new( 'host'=>$host_ip, 'timeout'=>10, 'log_level'=>$log_level );
	my ($user,$pwd)=('admin','cnm123');
	my $sid = $api->ws_get_token($user,$pwd);
	#print "sid=$sid\n";

	my $class='devices';
	my $endpoint = (exists $OPTS{'n'}) ? $OPTS{'n'}.'.json' : $OPTS{'id'}.'.json';

	my $response = $api->ws_get($class,$endpoint,{});

	#print Dumper($response);
   if ($response->[0]->{'name'} eq '') {
      print "**ERROR** SIN NOMBRE EN BBDD\n";
   }

#   $host_name = $response->[0]->{'name'};
#   if ($response->[0]->{'domain'} ne '') { $host_name .='.'.$response->[0]->{'domain'}; }

	$store_dir .= sprintf("%010d", $response->[0]->{'id'});

	#if ((exists $response->[0]->{'URL'}) && (ref($response->[0]->{'URL'}) eq 'ARRAY') ) {
	if (exists $response->[0]->{'URL'}) {
		my $url = eval($response->[0]->{'URL'});
		if ( ref($url) eq 'ARRAY') {
			foreach my $u (@{$url}) {push @ALL_URLS,$u; }
		}
	}
	#print Dumper($response);

}

elsif (! exists $OPTS{'l'}) {
   $script->usage($main::MYHEADER);
   exit 1;
}



my $VERBOSE=0;
if ( ($OPTS{'verbose'}) || ($OPTS{'v'}) ) { $VERBOSE=1; }

#if ($OPTS{'use_realm'}) {
#   $DESC{'use_realm'}=$OPTS{'use_realm'};
#   $DESC{'realm_user'}=$OPTS{'realm_user'};
#   $DESC{'realm_pwd'}=$OPTS{'realm_pwd'};
#}
#if ($OPTS{'use_proxy'}) {
#   $DESC{'use_proxy'}=$OPTS{'use_proxy'};
#   $DESC{'proxy_user'}=$OPTS{'proxy_user'};
#   $DESC{'proxy_pwd'}=$OPTS{'proxy_pwd'};
#   $DESC{'proxy_host'}=$OPTS{'proxy_host'};
#   $DESC{'proxy_port'}=$OPTS{'proxy_port'};
#}

foreach my $iid (@ALL_URLS) {

#	$DESC{'url'}=$iid;
#	$DESC{'store_id'} = $script->set_store_id($host_name,$iid);
#	$DESC{'store_dir'} = $script->store_dir();

   $DESC{'url'}=$iid;
   $DESC{'script_tag'} = $script_tag;
   $DESC{'store_dir'} = $store_dir;

	#--------------------------------------------------------------------
	my ($OO1,$OO2,$OO3,$OO4) = ("001.$iid", "002.$iid", "003.$iid", "004.$iid");

	my %TAGS=( 

		$OO1=>'Overall Score', $OO2=>'Size (bytes)', $OO3=>'Page Load Time (ms)',  $OO4=>'Number of requests',

	);

	if ($OPTS{'l'}) {
   	foreach my $tag (sort keys %TAGS) { print "<$tag>\t$TAGS{$tag}\n"; }
   	exit 0;
	}

	#--------------------------------------------------------------------
	my $results=mon_http_yslow(\%DESC);

	#--------------------------------------------------------------------
	$script->test_init($OO1,$TAGS{$OO1});
	$script->test_init($OO2,$TAGS{$OO2});
	$script->test_init($OO3,$TAGS{$OO3});
	$script->test_init($OO4,$TAGS{$OO4});
	$script->test_done($OO1,$results->{'o'});
	$script->test_done($OO2,$results->{'w'});
	$script->test_done($OO3,$results->{'lt'});
	$script->test_done($OO4,$results->{'r'});

}

$script->print_metric_data();

#--------------------------------------------------------------------
#--------------------------------------------------------------------
sub mon_http_yslow {
my $desc=shift;

   my %RESULTS = (
      'page_timings' => { 'total' => 0, 'onLoad' => 0, 'onContentLoad' => 0 },
      'timings' => { 'total' => 0, 'ssl' => 0, 'dns' => 0, 'send' => 0, 'connect' => 0, 'blocked' => 0, 'receive' => 0, 'other'=>0},
      'response_codes' => { '200' => 0, '4x' => 0, '5x' => 0, 'other' => 0},
      'num_requests' => { 'total' => 0, 'html'=>0, 'javascript'=>0, 'css'=>0, 'image'=>0, 'text'=>0, 'other'=>0 },
      'size_requests' => { 'total' => 0, 'html'=>0, 'javascript'=>0, 'css'=>0, 'image'=>0, 'text'=>0, 'other'=>0 },
   );


   my $url=$desc->{url};
   my $url_mod=$url;
   $url_mod=~s/http\:\/\///;
   $url_mod=~s/https\:\/\///;
   $url_mod=~s/\//-/g;

   my $lapse=3600;
   my $tnow=time();
   my $tmod = $tnow - ($tnow % $lapse);

   # El nombre delfichero se compone de: timestamp(normalizado)-md5(script_name)-md5(iid)-extra_info
   my $hiid = substr(md5_hex($url),0,6);
   my $tag_extra_data = $tmod.'-'.$script_tag.'-'.$hiid.'-'.$url_mod;

   #my $subdir='/opt/data/extra_data/'.$url_mod;
   my $subdir=$desc->{store_dir};

   if (! -d $subdir) { `/bin/mkdir -p $subdir`; }

   my $cmd = "/usr/local/bin/phantomjs /opt/cnm-sp/phantomjs-2.1.1/yslow-3.1.8.js --ua \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.97 Safari/537.11\" -i grade -f json  $url";
   my $grade = `$cmd 2>&1`;

	my $grade_decode={};
	eval {
		$grade_decode=decode_json($grade);
	};
	if ($@) {
		print "****ERROR****($@)\n$grade\n";
		return \%RESULTS;
	}

	
#   open (F,">$subdir/$tag_extra_data.yslow");
#   print F $grade;
#   close F;

	open my $z, '|-', "/bin/gzip > $subdir/$tag_extra_data.yslow.gz";
   print { $z } $grade;
	close $z ;


	if ($VERBOSE) {
		print Dumper($grade_decode);
		print "**SALIDA** $subdir/$tag_extra_data.yslow\n";
	}
	return $grade_decode;
}

