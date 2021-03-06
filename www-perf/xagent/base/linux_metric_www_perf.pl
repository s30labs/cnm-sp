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
# linux_metric_www_perf.pl -store_dir  -host_name 1.1.1.1 -iid xxx: Devuelve la ruta del extra_data
# linux_metric_www_perf.pl -h  : Ayuda
#
# -n          : IP remota
# -u          : URL
# -v/-verbose : Muestra informacion extra(debug)
# -h/-help    : Ayuda
# -l          : Lista las metricas que obtiene
# -store_dir  : Reporta la ruta donde se almacena el extra_data. Su valor es la IPdeldispositivo(podria ser tambien id_dev). Para calcular la ruta utiliza el nombre+deominio+iid  
# -iid        : Indica la instancia sobre la que se aplica el script (en caso de que proceda).
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

#	$host_name = $response->[0]->{'name'};
#	if ($response->[0]->{'domain'} ne '') { $host_name .='.'.$response->[0]->{'domain'}; }

   $store_dir .= sprintf("%010d", $response->[0]->{'id'});

#$script->set_store_id($host_name,$OPTS{'iid'});
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

	my $host_ip = 'localhost';
	my $api=CNMScripts::CNMAPI->new( 'host'=>$host_ip, 'timeout'=>10, 'log_level'=>$log_level );
	my ($user,$pwd)=('admin','cnm123');
	my $sid = $api->ws_get_token($user,$pwd);

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

	$DESC{'url'}=$iid;
	$DESC{'script_tag'} = $script_tag;
	$DESC{'store_dir'} = $store_dir;

	#--------------------------------------------------------------------
	my ($OO1,$OO2,$OO3,$OO4,$OO5,$OO6,$OO7,$OO8,$OO9) = ("001.$iid", "002.$iid", "003.$iid", "004.$iid", "005.$iid", "006.$iid", "007.$iid", "008.$iid","009.$iid");
	my ($O10,$O11,$O12,$O13) = ("010.$iid", "011.$iid", "012.$iid", "013.$iid");
	my ($O20,$O21,$O22,$O23,$O24,$O25,$O26) = ("020.$iid", "021.$iid", "022.$iid", "023.$iid", "024.$iid", "025.$iid", "026.$iid");
	my ($O30,$O31,$O32,$O33,$O34,$O35,$O36) = ("030.$iid", "031.$iid", "032.$iid", "033.$iid", "034.$iid", "035.$iid", "036.$iid");
	my ($O40,$O41,$O42) = ("040.$iid", "041.$iid", "042.$iid");

	my %TAGS=( 

		$OO1=>'Total Time (sg)', $OO2=>'Wait Time (sg)', $OO3=>'Receive Time (sg)', $OO4=>'Connect Time (sg)', $OO5=>'Blocked Time (sg)', $OO6=>'DNS Time (sg)', $OO7=>'Send Time (sg)', $OO8=>'SSL Time (sg)', $OO9=>'Other Time (sg)',

		$O10=>'Responses with code 200', $O11=>'Responses with codes 4x', $O12=>'Responses with codes 5x', $O13=>'Response with other codes',

		$O20=>'Total Requests Counter', $O21=>'Html Requests Counter', $O22=>'Javascript Requests Counter', $O23=>'CSS Requests Counter', $O24=>'Image Requests Counter', $O25=>'Text Requests Counter', $O26=>'Other Requests Counter',

		$O30=>'Total Requests Size (bytes)', $O31=>'Html Requests Size (bytes)', $O32=>'Javascript Requests Size (bytes)', $O33=>'CSS Requests Size (bytes)', $O34=>'Image Requests Size (bytes)', $O35=>'Text Requests Size (bytes)', $O36=>'Other Requests Size (bytes)',

		$O40=>'Total Load Time (sg)', $O41=>'onLoad Time (sg)', $O42=>'onContentLoad Time (sg)'
	);

	if ($OPTS{'l'}) {
   	foreach my $tag (sort keys %TAGS) { print "<$tag>\t$TAGS{$tag}\n"; }
   	exit 0;
	}

	#--------------------------------------------------------------------
	my $results=mon_http_perf(\%DESC);


	#--------------------------------------------------------------------
	$script->test_init($OO1,$TAGS{$OO1});
	$script->test_init($OO2,$TAGS{$OO2});
	$script->test_init($OO3,$TAGS{$OO3});
	$script->test_init($OO4,$TAGS{$OO4});
	$script->test_init($OO5,$TAGS{$OO5});
	$script->test_init($OO6,$TAGS{$OO6});
	$script->test_init($OO7,$TAGS{$OO7});
	$script->test_init($OO8,$TAGS{$OO8});
	$script->test_init($OO9,$TAGS{$OO9});
	$script->test_done($OO1,$results->{'timings'}->{'total'});
	$script->test_done($OO2,$results->{'timings'}->{'wait'});
	$script->test_done($OO3,$results->{'timings'}->{'receive'});
	$script->test_done($OO4,$results->{'timings'}->{'connect'});
	$script->test_done($OO5,$results->{'timings'}->{'blocked'});
	$script->test_done($OO6,$results->{'timings'}->{'dns'});
	$script->test_done($OO7,$results->{'timings'}->{'send'});
	$script->test_done($OO8,$results->{'timings'}->{'ssl'});
	$script->test_done($OO9,$results->{'timings'}->{'other'});

	#-------------------------------------
	$script->test_init($O10,$TAGS{$O10});
	$script->test_init($O11,$TAGS{$O11});
	$script->test_init($O12,$TAGS{$O12});
	$script->test_init($O13,$TAGS{$O13});
	$script->test_done($O10,$results->{'response_codes'}->{'200'});
	$script->test_done($O11,$results->{'response_codes'}->{'4x'});
	$script->test_done($O12,$results->{'response_codes'}->{'5x'});
	$script->test_done($O13,$results->{'response_codes'}->{'other'});

	#-------------------------------------
	$script->test_init($O20,$TAGS{$O20});
	$script->test_init($O21,$TAGS{$O21});
	$script->test_init($O22,$TAGS{$O22});
	$script->test_init($O23,$TAGS{$O23});
	$script->test_init($O24,$TAGS{$O24});
	$script->test_init($O25,$TAGS{$O25});
	$script->test_init($O26,$TAGS{$O26});
	$script->test_done($O20,$results->{'num_requests'}->{'total'});
	$script->test_done($O21,$results->{'num_requests'}->{'html'});
	$script->test_done($O22,$results->{'num_requests'}->{'javascript'});
	$script->test_done($O23,$results->{'num_requests'}->{'css'});
	$script->test_done($O24,$results->{'num_requests'}->{'image'});
	$script->test_done($O25,$results->{'num_requests'}->{'text'});
	$script->test_done($O26,$results->{'num_requests'}->{'other'});

	#-------------------------------------
	$script->test_init($O30,$TAGS{$O30});
	$script->test_init($O31,$TAGS{$O31});
	$script->test_init($O32,$TAGS{$O32});
	$script->test_init($O33,$TAGS{$O33});
	$script->test_init($O34,$TAGS{$O34});
	$script->test_init($O35,$TAGS{$O35});
	$script->test_init($O36,$TAGS{$O36});
	$script->test_done($O30,$results->{'size_requests'}->{'total'});
	$script->test_done($O31,$results->{'size_requests'}->{'html'});
	$script->test_done($O32,$results->{'size_requests'}->{'javascript'});
	$script->test_done($O33,$results->{'size_requests'}->{'css'});
	$script->test_done($O34,$results->{'size_requests'}->{'image'});
	$script->test_done($O35,$results->{'size_requests'}->{'text'});
	$script->test_done($O36,$results->{'size_requests'}->{'other'});

	#-------------------------------------
	$script->test_init($O40,$TAGS{$O40});
	$script->test_init($O41,$TAGS{$O41});
	$script->test_init($O42,$TAGS{$O42});
	$script->test_done($O40,$results->{'page_timings'}->{'total'});
	$script->test_done($O41,$results->{'page_timings'}->{'onLoad'});
	$script->test_done($O42,$results->{'page_timings'}->{'onContentLoad'});

}
$script->print_metric_data();

#--------------------------------------------------------------------
#--------------------------------------------------------------------
sub mon_http_perf {
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
	
	my $lapse=300;
	my $tnow=time();
   my $tmod = $tnow - ($tnow % $lapse);

	# El nombre delfichero se compone de: timestamp(normalizado)-md5(script_name)-md5(iid)-extra_info
	my $hiid = substr(md5_hex($url),0,6);
	my $tag_extra_data = $tmod.'-'.$script_tag.'-'.$hiid.'-'.$url_mod;

   #my $subdir='/opt/data/extra_data/'.$url_mod;
   my $subdir=$desc->{store_dir};

   #if ($subdir !~ /\/$/) { $subdir .=  '/'; }
   #$subdir .= $desc->{store_id};

   if (! -d $subdir) { `/bin/mkdir -p $subdir`; }

   my $cmd = "/usr/local/bin/phantomjs /opt/cnm-sp/phantomjs-2.1.1/www-perf.js $url '$tag_extra_data' $subdir";
   my $har = `$cmd`;

	if ($OPTS{'har'}) {
		open (F,">/tmp/test.har");
		print F $har;
		close F;
	}

	my $har_decode={};
	eval {
		$har_decode=decode_json($har);
	};
	if ($@) {
		print "****ERROR****($@)\n$har\n";
#      open (F,">/$subdir/$tag_extra_data.error");
#      print F "****ERROR****($@)\n$har\n";;
#      close F;

		return \%RESULTS;
	}

	#print Dumper($har_decode->{'log'}->{'pages'});
	#print Dumper($har_decode->{'log'}->{'entries'});

#$VAR1 = [
#          {
#            'pageTimings' => {
#                               'onLoad' => 675
#                             },
#            'title' => 'What is CNM?',
#            'startedDateTime' => '2016-04-18T17:13:52.681Z',
#            'id' => 'http://www.s30labs.com'
#          }
#        ];

	if (exists $har_decode->{'log'}->{'pages'}->[0]->{'pageTimings'}->{'onLoad'}) {
		$RESULTS{'page_timings'}->{'onLoad'} = $har_decode->{'log'}->{'pages'}->[0]->{'pageTimings'}->{'onLoad'}/1000; 
	}
	if (exists $har_decode->{'log'}->{'pages'}->[0]->{'pageTimings'}->{'onContentLoad'}) {
		$RESULTS{'page_timings'}->{'onContentLoad'} = $har_decode->{'log'}->{'pages'}->[0]->{'pageTimings'}->{'onContentLoad'}/1000; 
	}
	$RESULTS{'page_timings'}->{'total'} = $RESULTS{'page_timings'}->{'onLoad'} + $RESULTS{'page_timings'}->{'onContentLoad'};

	#my ($cnt,$total_size)=(0,0);
	my %all_status_codes=();
	foreach my $h (@{$har_decode->{'log'}->{'entries'}}) {
		
		#$cnt+=1;
		#$total_size+=$h->{'response'}->{'bodySize'};

		foreach my $k (keys %{$h->{'timings'}}) {
			if ($h->{'timings'}->{$k} > 0) { 
				$RESULTS{'timings'}->{$k} += $h->{'timings'}->{$k}; 
				if (($k ne 'receive') && ($k ne 'wait')) { $RESULTS{'timings'}->{'other'}+=1; } 
			}
		} 
		$RESULTS{'timings'}->{'total'}+=$h->{'time'};

		my $ctype='';
		my $server='';
		foreach my $header (@{$h->{'response'}->{'headers'}}) {
			if ($header->{'name'} eq 'Content-Type') { $ctype=$header->{'value'}; }
			if ($header->{'name'} eq 'Server') { $server=$header->{'value'}; }
		}

		# Status Codes
		my $status_code=$h->{'response'}->{'status'};
		if (! exists $all_status_codes{$status_code}) { $all_status_codes{$status_code} = 1; }
		else { $all_status_codes{$status_code}+=1; }
		if ($status_code==200) { $RESULTS{'response_codes'}->{'200'} += 1; }
		elsif ($status_code>=500) { $RESULTS{'response_codes'}->{'5x'} += 1; }
		elsif ($status_code>=400) { $RESULTS{'response_codes'}->{'4x'} += 1; }
		else { $RESULTS{'response_codes'}->{'other'} += 1; }

		# Resource types
      my $gtype='other';
      if ($ctype=~/image\//) { $gtype='image'; }
      elsif ($ctype=~/text\/css/) { $gtype='css'; }
      elsif ($ctype=~/text\/html/) { $gtype='html'; }
      elsif ($ctype=~/text\/plain/) { $gtype='text'; }
      elsif ($ctype=~/javascript/) { $gtype='javascript'; }
      #elsif ($ctype=~/\//) { $gtype=''; }

      if (! exists $RESULTS{'size_requests'}->{$gtype}) { $RESULTS{'size_requests'}->{$gtype} = $h->{'response'}->{'bodySize'}; }
      else { $RESULTS{'size_requests'}->{$gtype}+=$h->{'response'}->{'bodySize'}; }
		$RESULTS{'size_requests'}->{'total'} += $h->{'response'}->{'bodySize'};

      if (! exists $RESULTS{'num_requests'}->{$gtype}) { $RESULTS{'num_requests'}->{$gtype} = 1; }
      else { $RESULTS{'num_requests'}->{$gtype}+=1; }
		$RESULTS{'num_requests'}->{'total'} += 1;

		if ($VERBOSE) {
			print $h->{'request'}->{'httpVersion'}.' '.$h->{'request'}->{'method'}.' '.$ctype."\t"; 
			print '['.$status_code."]\t".$h->{'response'}->{'statusText'}."\t".$server.' '.$h->{'request'}->{'url'}."\n";
#		if ($h->{'response'}->{'status'} >=400) { print "\t****".$h->{'request'}->{'url'}."\n"; }
#		elsif ($h->{'response'}->{'status'} >=300) { print "\t----".$h->{'request'}->{'url'}."\n"; }
		}

	}


	foreach my $t (keys %{$RESULTS{'timings'}}) {
		$RESULTS{'timings'}->{$t}/=1000;
	}

#	my $twait=$RESULTS{'timings'}->{'wait'}/1000;	
#	my $treceive=$RESULTS{'timings'}->{'receive'}/1000;
#	my $total_time=$RESULTS{'timings'}->{'total'}/=1000;
#
#	print "cnt=$cnt objects (size = $total_size)\n";
#	print "time = $total_time (wait=$twait | receive=$treceive)\n";

	if ($VERBOSE) {
		print Dumper(\%all_status_codes);
		print Dumper(\%RESULTS);
	}
	return \%RESULTS;
}

