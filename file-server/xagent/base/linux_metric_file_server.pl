#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME:  linux_metric_file_server.pl
# AUTHOR: <fmarin\@s30labs.com>
# DATE: 26/03/2018
# VERSION: 1.0
#
# DESCRIPTION:
# Monitoriza que se transfieren correctamente ficheros al servidor especificado
# 0=OK | 1=Error conexion | 2=Error Timeout| 3=Error sftp (no existe el diectorio ....)
#
# USAGE:
# linux_metric_file_server.pl -host 1.1.1.1 -user user1 -pwd xxx [-port 22|...] [-proto sftp|...] [-files 10|...] [-size 100000|...] [-pattern a,b,c] [-v]
# linux_metric_file_server.pl -h  : Help
#
# -host       : File Server Host
# -port       : Port (default 22)
# -user       : Server User
# -pwd        : Server User Password
# -proto      : Protocol (default sftp)
# -action     : test|count
# -files      : Number of files used (tx/rx). Default is 10. (mode=test)
# -size       : Aggregated size. Default is 300KB. (mode=test)
# -remotedir  : Remote directory  (mode=count|test)
# -lapse      : Defines a time reference (tRef) = Tnow-lapse in mode=count.
# -pattern    : Text pattern (or patterns) for file classification in mode count
# -timeout    : Max. Timeout [Default 20 sg]
# -v/-verbose : Verbose output (debug)
# -h/-help    : Help
#
# OUTPUT:
# <001> File Transfer Latency = 0.008458
# <002> File Transfer Success = 100
# <003> Total Files = 8579
# <003.CM_> Total Files (CM_) = 1452
# <003.MP_> Total Files (MP_) = 2563
# <003.SS_> Total Files (SS_) = 1986
# <003.ST_> Total Files (ST_) = 2578
# <004> Latest File Modification Time = 1532024497
# <005> Oldest File Modification Time = 1529624299
# <006> Total Files before lapse = 8554
# <006.CM_> Total Files before lapse (CM_) = 1449
# <006.MP_> Total Files before lapse (MP_) = 2555
# <006.SS_> Total Files before lapse (SS_) = 1980
# <006.ST_> Total Files before lapse (ST_) = 2570
# <007> Total Files after lapse = 25
# <007.CM_> Total Files after lapse (CM_) = 3
# <007.MP_> Total Files after lapse (MP_) = 8
# <007.SS_> Total Files after lapse (SS_) = 6
# <007.ST_> Total Files after lapse (ST_) = 8
# <008> Time lapse with no files  = 1532
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
use Data::Dumper;
use Digest::MD5 qw(md5_hex);
use Time::HiRes qw(gettimeofday tv_interval);
use Net::SFTP::Foreign;
use Fcntl qw(S_ISDIR);

#$Net::SFTP::Foreign::debug=-1;

#--------------------------------------------------------------------
$SIG{ALRM} = sub { die "timeout" };

#--------------------------------------------------------------------
#--------------------------------------------------------------------
my $script = CNMScripts->new();

my %opts = ();
my $ok=GetOptions (\%opts,  'h','help','v','verbose','user=s','pwd=s','port=s','host=s','proto=s','action=s','files=s','size=s','lapse=s','remotedir=s','pattern=s','timeout=s' );
if (! $ok) {
	print STDERR "***ERROR EN EL PASO DE PARAMETROS***\n";	
	$script->usage($main::MYHEADER); 
	exit 1;
}

my $VERBOSE = ((defined $opts{'v'}) || (defined $opts{'verbose'})) ? 1 : 0;

if ( ($opts{'h'}) || ($opts{'help'})) { $script->usage($main::MYHEADER); }

my $host = ($opts{'host'}) ? $opts{'host'} : $script->usage($main::MYHEADER);

my $proto = (defined $opts{'proto'}) ? $opts{'proto'} : 'sftp';
my $port =22;
if ($proto=~/sftp/i) { $port =22; }

my $action = (defined $opts{'action'}) ? $opts{'action'} : 'test';
my $remote_dir = (defined $opts{'remotedir'}) ? $opts{'remotedir'} : '/';

my $lapse = (defined $opts{'lapse'}) ? $opts{'lapse'} : 0; 

my $timeout = (defined $opts{'timeout'}) ? $opts{'timeout'} : 20; 

my $pattern_cmd = (defined $opts{'pattern'}) ? $opts{'pattern'} : ''; 
my @pattern=();
my %cnt_all_pat=();
my %cnt_before_pat=();
my %cnt_after_pat=();

if ($pattern_cmd ne '') { 
	@pattern=split(',', $pattern_cmd);
	foreach my $p (@pattern) {
		$cnt_all_pat{$p}=0;
		$cnt_before_pat{$p}=0;
		$cnt_after_pat{$p}=0;
	}
}
my $npattern=scalar(@pattern);

my $user = (defined $opts{'user'}) ? $opts{'user'} : '';
my $pwd = (defined $opts{'pwd'}) ? $opts{'pwd'} : '';

my $NUM_FILES = (defined $opts{'files'}) ? $opts{'files'} : 10;		# 10 files
my $TOTAL_SIZE = (defined $opts{'size'}) ? $opts{'size'} : 300000;   # 300KB

if ($VERBOSE) {
   print "PARAMETERS *****\n";
   print Dumper (\%opts);
   print "ip=$host port=$port user=$user pwd=$pwd timeout=$timeout pattern_cmd=$pattern_cmd npattern=$npattern\n";
   print "*****\n";
}

#--------------------------------------------------------------------
my $id=join('-',$opts{'host'},$opts{'port'},$opts{'action'},$opts{'remotedir'},$opts{'pattern'});
my $store_id=$script->set_store_id($id);
$script->mkstore();
if ($VERBOSE) {
	print "store_id = $store_id\n"; 
}
#--------------------------------------------------------------------
my $tnow=time();
my ($r,$data,$value,$num_ok,$RC) = ('','',0,0,1);
my ($cnt_all, $cnt_before, $cnt_after, $ts_latest, $ts_oldest) = (0,0,0,0,$tnow);

# $value => 0=OK | 1=UNK  | 2=Error en getToken | 3=Error en validateToken

#action=test
$script->test_init('001', "File Transfer Latency (sg)");
$script->test_init('001RC', "STATUS - File Transfer Latency (sg)");
$script->test_init('002', "File Transfer Success (%)");
$script->test_init('002RC', "STATUS - File Transfer Success (%)");

#action=count
$script->test_init('003', "Total Files");
$script->test_init('003RC', "STATUS - Total Files");
$script->test_init('004', "Latest File Modification Time");
$script->test_init('004RC', "STATUS - Latest File Modification Time");
$script->test_init('005', "Oldest File Modification Time");
$script->test_init('005RC', "STATUS - Oldest File Modification Time");
$script->test_init('006', "Total Files before lapse");
$script->test_init('006RC', "STATUS - Total Files before lapse");
$script->test_init('007', "Total Files after lapse");
$script->test_init('007RC', "STATUS - Total Files after lapse");
$script->test_init('008', "Time lapse with no files");
$script->test_init('008RC', "STATUS - Time lapse with no files");



#--------------------------------------------------------------------
my $t0=[gettimeofday];
my $connect_timeout=5;
my ($code,$error)=(0,'');

#--------------------------------------------------------------------
if ($proto=~/sftp/i) {

	# -o => 'StrictHostKeyChecking=no'
	my $sftp = Net::SFTP::Foreign->new( $host, 'port'=>$port, 'user'=>$user, 'password'=>$pwd, 'timeout'=>$connect_timeout );

  	$script->log('info',"--CONNECT-- $host $action");
	if ($sftp->error) {
		$RC=1;
   	#$sftp->die_on_error("Unable to establish SFTP connection");
		$error = $sftp->error;
   	$script->log('info',"**ERROR** $error");
		$script->print_metric_all(	{'001'=>$connect_timeout, '002'=>0, '003'=>0, '004'=>0, '005'=>0, '006'=>0, '007'=>0, '008'=>0,
											'001RC'=>$RC, '002RC'=>$RC, '003RC'=>$RC, '004RC'=>$RC, '005RC'=>$RC, '006RC'=>$RC, '007RC'=>$RC, '008RC'=>$RC},
											{'[*][error]'=>$error} );
		exit $RC;
	}

	eval {

		alarm($timeout);

		#--------------------------------------------------------------
		if ($action=~/count/i) {

			#my $remote_dir='icgappESP/Inbox/Processed/';
			my $ls = $sftp->ls($remote_dir);
			if ($sftp->error) {
				$RC=3;
		      $error = $sftp->error;
      		$script->log('info',"**ERROR** $error");
      		$script->print_metric_all( {'003'=>0, '004'=>0, '005'=>0, '006'=>0, '007'=>0, '008'=>0,
													'001RC'=>$RC, '002RC'=>$RC, '003RC'=>$RC, '004RC'=>$RC, '005RC'=>$RC, '006RC'=>$RC, '007RC'=>$RC, '008RC'=>$RC },
            		                     {'[003][error]'=>$error} );
      		exit $RC;
			}


			my $tref=0;
			if ($lapse>0) { $tref=$tnow-$lapse; }
	
			foreach my $l (@$ls) {
				#if ($tnow-$l->{a}->mtime) {}
				if (S_ISDIR($l->{a}->perm)) { next; }
				#print Dumper ($l),"\n";

				if ($VERBOSE) { print "$l->{longname}\t$l->{filename} \n"; }

				$cnt_all++;
				if ($npattern>0) {
					foreach my $p (@pattern) {
						if ($l->{filename} =~ /$p/) { 
							$cnt_all_pat{$p} += 1; 
						}
					}
				}

				my $mt=$l->{a}->atime;

            if ($mt > $ts_latest) { $ts_latest=$mt; }
				if ($mt < $ts_oldest) { $ts_oldest=$mt; }
			
				if ($lapse == 0 ) { next; }

				if ($mt<$tref) { 
					$cnt_before++; 
	            if ($npattern>0) {
   	            foreach my $p (@pattern) {
      	            if ($l->{filename} =~ /$p/) {
         	            $cnt_before_pat{$p} += 1;
            	      }
            		}
					}
				}
				else { 
					$cnt_after++; 
               if ($npattern>0) {
                  foreach my $p (@pattern) {
                     if ($l->{filename} =~ /$p/) {
                        $cnt_after_pat{$p} += 1;
                     }
                  }
               }
				}
			} 

#($cnt_all, $cnt_before, $cnt_after, $ts_latest, $ts_oldest)

			my $tref_oldest=$tnow-$ts_oldest;
			my $tref_latest = ($ts_latest==0) ? 0 : $tnow-$ts_latest;

			my $lapse_nofiles=0;
			if ($ts_latest!=0) { $script->set_store_status('',{'last_ts_with_files'=>$tnow}); }
			else {
				my $status = $script->get_store_status();
				$lapse_nofiles = (exists $status->{'last_ts_with_files'}) ? $tnow-$status->{'last_ts_with_files'} : 0;
			}

			$RC=0;
	
			if ($npattern==0) {
         	$script->print_metric_all( {
							'003'=>$cnt_all, '004'=>$tref_latest, '005'=>$tref_oldest, '006'=>$cnt_before, '007'=>$cnt_after, '008'=>$lapse_nofiles,
							'001RC'=>$RC, '002RC'=>$RC, '003RC'=>$RC, '004RC'=>$RC, '005RC'=>$RC, '006RC'=>$RC, '007RC'=>$RC, '008RC'=>$RC} );
			}
			else {
				my %result = ( '003'=>$cnt_all, '004'=>$tref_latest, '005'=>$tref_oldest, '006'=>$cnt_before, '007'=>$cnt_after, '008'=>$lapse_nofiles,
									'001RC'=>$RC, '002RC'=>$RC, '003RC'=>$RC, '004RC'=>$RC, '005RC'=>$RC, '006RC'=>$RC, '007RC'=>$RC, '008RC'=>$RC);
				foreach my $k (sort keys %cnt_all_pat) { 
					my $tag="003.$k";
					$script->test_init($tag, "Total Files ($k)");
					$result{$tag}=$cnt_all_pat{$k}; 
				}
				foreach my $k (sort keys %cnt_before_pat) { 
               my $tag="006.$k";
               $script->test_init($tag, "Total Files before lapse ($k)");
               $result{$tag}=$cnt_before_pat{$k};
				}
				foreach my $k (sort keys %cnt_after_pat) { 
               my $tag="007.$k";
               $script->test_init($tag, "Total Files after lapse ($k)");
               $result{$tag}=$cnt_after_pat{$k};

				}
				$script->print_metric_all(\%result);
			}

			exit $RC;

		}

		# action = test (default)
		#--------------------------------------------------------------
		my @TEST_FILES = ();
		my $SCRATCH_DIR = '/tmp/scratch';
		if (! -d $SCRATCH_DIR) { mkdir $SCRATCH_DIR; }
		my $CHUNK_SIZE=5;
		my $TOP_RANDOM=100000; # Tantos ceros como $CHUNK_SIZE
		my $chunks_per_file = int($TOTAL_SIZE/($NUM_FILES*$CHUNK_SIZE));
		foreach my $i (1..$NUM_FILES) {
			my $ii = sprintf("%03d",$i);
		   my $fnametx = $SCRATCH_DIR.'/cnm_file_server_local_'.$ii.'.txt';
   		my $fnamerx = 'cnm_file_server_remote_'.$ii.'.txt';
			my $pattern = int(rand($TOP_RANDOM));
   		open (F, ">$fnametx");
   		print F $pattern x $chunks_per_file;
   		close F;
   		my $md5 = get_file_md5($fnametx);
 	 	 	push @TEST_FILES,{ 'fnametx'=>$fnametx, 'fnamerx'=>$fnamerx, 'md5'=>$md5 };
		}

		my $x=1;
		foreach my $h (@TEST_FILES) {

			my $ok = $sftp->put($h->{'fnametx'}, $h->{'fnamerx'});
			if (! $ok) { print STDERR "put failed: " . $sftp->error. "\n"; }
			elsif ($VERBOSE) { 
				my $xf = sprintf("%03d",$x);
				print "PUT FILE [$xf] >> OK >> $h->{'fnametx'} >> [$h->{'md5'}]\n"; 
			}
			$x++;
		}


		$x=1;
		$num_ok=0;
		foreach my $h (@TEST_FILES) {

			my $frx=$SCRATCH_DIR.'/'.$h->{'fnamerx'};
   		my $ok = $sftp->get($h->{'fnamerx'},$frx);
   		if (! $ok) { print STDERR "GET failed: " . $sftp->error. "\n"; }
   		else {
				my $md5 = get_file_md5($frx);
				my $md5check = 'ERROR';
				if ($md5 eq $h->{'md5'}) { 
					$md5check = 'OK'; 
					$num_ok++;
				} 
				if ($VERBOSE) { 
					my $xf = sprintf("%03d",$x);
					print "GET FILE [$xf] >> $md5check >> $frx >> $md5\n"; 
				}
			}
			$sftp->remove($h->{'fnamerx'});
   		$x++;
		}

		alarm(0);
	};

	if ($@) {
		$RC=2;
		$error = ($@=~/timeout/i) ? "Timeout ($timeout sg)" : $@;
		$script->log('info',"**ERROR** host=$host port=$port user=$user pwd=$pwd [$@]");
      $script->print_metric_all( {'001'=>$timeout, '002'=>0, '003'=>0, '004'=>0, '005'=>0, '006'=>0, '007'=>0, '008'=>0,
											'001RC'=>$RC, '002RC'=>$RC, '003RC'=>$RC, '004RC'=>$RC, '005RC'=>$RC, '006RC'=>$RC, '007RC'=>$RC, '008RC'=>$RC},
                                 {'[*][error]'=>$error} );

		exit $RC;

	}

	my $t1=[gettimeofday];
	my $elapsed = tv_interval ( $t0, $t1);
	my $elapsed3 = sprintf("%.6f", $elapsed);
#	$script->test_done('001',$elapsed3);

	$code = $sftp->status();
	$error = $sftp->error();
	if (($code == 0) || ($error=~/success/i)) { 
		$RC=0; 
		$value = int(($num_ok/$NUM_FILES)*100);
		$script->print_metric_all( {'001'=>$elapsed3, '002'=>$value, '003'=>0, '004'=>0, '005'=>0, '006'=>0, '007'=>0, '008'=>0,
											'001RC'=>$RC, '002RC'=>$RC, '003RC'=>$RC, '004RC'=>$RC, '005RC'=>$RC, '006RC'=>$RC, '007RC'=>$RC, '008RC'=>$RC} );
	}
	else {
		$RC=3;
		$script->log('info',"**ERROR** host=$host port=$port user=$user pwd=$pwd [$code - $error]");
		if ($VERBOSE) { print "**ERROR** host=$host port=$port user=$user pwd=$pwd [$code - $error]\n"; }
		$value=0;
		my $code_error="$code - $error";
		$script->print_metric_all( {'001'=>$elapsed3, '002'=>$value, '003'=>0, '004'=>0, '005'=>0, '006'=>0, '007'=>0, '008'=>0,
											'001RC'=>$RC, '002RC'=>$RC, '003RC'=>$RC, '004RC'=>$RC, '005RC'=>$RC, '006RC'=>$RC, '007RC'=>$RC, '008RC'=>$RC},
											{'[*][error]'=>$code_error} );
	}
}

exit $RC;


#--------------------------------------------------------------------
#--------------------------------------------------------------------
sub get_file_md5 {
my ($file)=@_;

	local $/ = undef;
	if (! -f $file) { return undef; }
	open (F, "<$file");
	my $data = <F>;
	my $hash = md5_hex($data);
	close F;
	
	return $hash;
}


