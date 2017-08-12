#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME:  linux_metric_ssh_linuxOS.pl
# AUTHOR: Fernando Marin <fmarin\@s30labs.com>
# DATE: 27/01/2015
# VERSION: 1.0
#
# DESCRIPTION:
# Obtiene metricas de SO en un host remoto LINUX mediante una conexion  SSH 
#
# USAGE:
# linux_metric_ssh_linuxOS.pl -n 1.1.1.1 [-port 2322]
# linux_metric_ssh_linuxOS.pl -n 1.1.1.1 -user=aaa -pwd=bbb
# linux_metric_ssh_linuxOS.pl -n 1.1.1.1 -user=aaa -key_file=/etc/ssh/id_rsa
# linux_metric_ssh_linuxOS.pl -n 1.1.1.1 -user=aaa -key_file=1
# linux_metric_ssh_linuxOS.pl -h  : Ayuda
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
   '001_process' => "/bin/ps -eo pid,state,bsdtime,etime,cmd",
   '003_uptime' => "/usr/bin/awk '{print \$1}' /proc/uptime",
   '004_list_of_open_files' => '/usr/bin/lsof +c 0',
   '005_disk_inodes' => '/bin/df -i',
	'006_loadavg' => '/bin/cat /proc/loadavg',
   '007_proc_stat' => '/bin/cat /proc/stat',
   '008_proc_net' => '/bin/cat /proc/net/dev',
   '009_sys_net' => '/bin/grep "" /sys/class/net/*/* 2>&1', #Se prescinde de stderr porque en lo siempre hay
   '010_disk_size' => '/bin/df',
);

my %PARSERS = (

   '001_process' => \&process,
   '003_uptime' => \&uptime,
   '004_list_of_open_files' => \&list_of_open_files,
   '005_disk_inodes' => \&disk_inodes,
	'006_loadavg' => \&loadavg,
   '007_proc_stat' => \&proc_stat,
   '008_proc_net' => \&proc_net,
   '009_sys_net' => \&sys_net,
   '010_disk_size' => \&disk_size,
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
# 'process' => "/bin/ps -eo state | /bin/grep -c Z",
#root@cnm-devel:/opt/custom_pro/conf/proxy-pkgs# /bin/ps -eo pid,state,bsdtime,etime,cmd |more
#  PID S   TIME     ELAPSED CMD
#    1 S   0:00    11:42:34 init [2]
#    2 S   0:00    11:42:34 [kthreadd]

sub process {
my ($script,$stdout, $stderr) = @_;

	my %TAGS=( '001'=>'Zombie Process', '002'=>'Process Uptime (min)');
	if ($LIST_METRICS) { 
		foreach my $tag (sort keys %TAGS) { print "<$tag>\t$TAGS{$tag}\n"; }
		return;
	}

   $script->test_init('001',$TAGS{'001'});
   $script->test_init('002',$TAGS{'002'});
   if ($stderr ne '') {
      $script->test_done('001','U');
      $script->test_done('002','U');
      return;
   }

   my %uptimes=();
	my $nzombies=0;
   my @lines = split (/\n/, $stdout);
   foreach my $l (@lines) {
      chomp;
		if ($l!~/^\s*(\d+)\s+(\w+)\s+(\S+)\s+(\S+)\s+(.*)$/) {
			#print "NOK=$l\n";
			next;
		}
		my ($pid,$stat,$time,$elapsed,$cmd) = ($1,$2,$3,$4,$5);
		if ($stat eq 'Z') {$nzombies++; }

		$cmd=~s/\[(.+)\]/$1/;
		my $k=$cmd;
		if ($cmd=~/^(\S+)\s.*/) { $k=$1; }
#		my $k=substr $cmd,0,10;

		$uptimes{$k}=0;
		if ($elapsed=~/(\d+)\:(\d+)\:(\d+)/) { $uptimes{$k}=$1*3600+$2*60+$3;}
		elsif ($elapsed=~/(\d+)\:(\d+)/) { $uptimes{$k}=$1*60+$2;}
   }

   $script->test_done('001',$nzombies);
   $script->test_done('002',\%uptimes);
}

#--------------------------------------------------------------------
# 'uptime' => "/usr/bin/awk '{print \$1}' /proc/uptime",
# 18:29:06 up 13:28,  2 users,  load average: 0.03, 0.02, 0.00
sub uptime {
my ($script,$stdout, $stderr) = @_;

	my %TAGS=( '003'=>'System uptime' );
   if ($LIST_METRICS) {
      foreach my $tag (sort keys %TAGS) { print "<$tag>\t$TAGS{$tag}\n"; }
      return;
   }

   $script->test_init('003',$TAGS{'003'});
   if (($stdout=~/\d+/) && ($stderr eq '')) {
      $script->test_done('003',$stdout);
   }
   else { $script->test_done('003','U'); }
}


#--------------------------------------------------------------------
#'list_of_open_files' => '/usr/bin/lsof',
#/usr/bin/lsof | perl -lane '\$x{"\$F[0]:\$F[1]"}++; END { print "\$x{\$_}\t\$_\" for sort {\$x{\$a}<=>\$x{\$b}} keys \%x}',
#COMMAND     PID        USER   FD      TYPE             DEVICE   SIZE/OFF    NODE NAME
#init          1        root  cwd       DIR                8,3       4096       2 /
#init          1        root  txt       REG                8,3      36992  523364 /sbin/init
#init          1        root   10u     FIFO                0,5        0t0    2408 /dev/initctl
#kthreadd      2        root  cwd       DIR                8,3       4096       2 /
#kthreadd      2        root  rtd       DIR                8,3       4096       2 /
#
sub list_of_open_files {
my ($script,$stdout, $stderr) = @_;

   my %TAGS=( '004'=>'Files opened by process' );
   if ($LIST_METRICS) {
      foreach my $tag (sort keys %TAGS) { print "<$tag>\t$TAGS{$tag}\n"; }
      return;
   }

   $script->test_init('004',$TAGS{'004'});
   if ($stderr ne '') { 
		$script->test_done('004','U');
		return;
	}

	my %R=();
	my @lines = split (/\n/, $stdout);
	foreach my $l (@lines) {
		chomp;
		my @c = split(/\s+/, $l);
		$R{$c[0]}++; 
	}

	$script->test_done('004',\%R);
}


#--------------------------------------------------------------------
# 'disk_inodes' => '/bin/df -i'
#Filesystem            Inodes   IUsed   IFree IUse% Mounted on
#/dev/sda3             915712  219353  696359   24% /
#tmpfs                 257675       4  257671    1% /lib/init/rw

sub disk_inodes {
my ($script,$stdout, $stderr) = @_;

   my %TAGS=( '005'=>'Total Inodes', '006'=>'Used Inodes', '007'=>'Free Inodes', '008'=>'Used Inodes (%)' );
   if ($LIST_METRICS) {
      foreach my $tag (sort keys %TAGS) { print "<$tag>\t$TAGS{$tag}\n"; }
      return;
   }

   foreach my $tag (sort keys %TAGS) { $script->test_init($tag,$TAGS{$tag}); }

   if ($stderr ne '') {
      foreach my $tag (sort keys %TAGS) { $script->test_done($tag,'U'); }
      return;
   }

   my %itotal=();
	my %iused=();
	my %ifree=();
	my %itotalp=();
   my @lines = split (/\n/, $stdout);
   foreach my $l (@lines) {
      chomp;
		if ($l=~/^\s*(\S+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)%\s+(.*)$/) {
			my $iid=$6;
			$itotal{$iid}=$2;	
			$iused{$iid}=$3;	
			$ifree{$iid}=$4;	
			$itotalp{$iid}=$5;
		}	
   }

   $script->test_done('005',\%itotal);
   $script->test_done('006',\%iused);
   $script->test_done('007',\%ifree);
   $script->test_done('008',\%itotalp);
}

#--------------------------------------------------------------------
# 'uptime' => "/usr/bin/awk '{print \$1}' /proc/uptime",
# 18:29:06 up 13:28,  2 users,  load average: 0.03, 0.02, 0.00
sub loadavg {
my ($script,$stdout, $stderr) = @_;

   my %TAGS=( '009'=>'Load 1m', '010'=>'Load 5m', '011'=>'Load 15m' );
   if ($LIST_METRICS) {
      foreach my $tag (sort keys %TAGS) { print "<$tag>\t$TAGS{$tag}\n"; }
      return;
   }

	foreach my $tag (sort keys %TAGS) { $script->test_init($tag,$TAGS{$tag}); }

   if ($stderr ne '') {
		foreach my $tag (sort keys %TAGS) { $script->test_done($tag,'U'); }
      return;
   }

	chomp $stdout;
	my @data = split(/\s+/, $stdout);
	if ($data[0]=~/([\d+|\.*])+/) { $script->test_done('009',$data[0]); }
	if ($data[1]=~/([\d+|\.*])+/) { $script->test_done('010',$data[1]); }
	if ($data[2]=~/([\d+|\.*])+/) { $script->test_done('011',$data[2]); }

}

#--------------------------------------------------------------------
# http://www.linuxhowtos.org/System/procstat.htm
# 'proc_stat' => /bin/cat /proc/stat´'
sub proc_stat {
my ($script,$stdout, $stderr) = @_;

   my %TAGS=( '012'=>'CPU User', '013'=>'CPU Nice', '014'=>'CPU System', '015'=>'CPU IOwait', '016'=>'CPU Irq', '017'=>'CPU SoftIrq', '018'=>'CPU Interrupts', '019'=>'CPU Context Switches', '020'=>'Processes', '021'=>'Processes Run', '022'=>'Processes Blocked' );
   if ($LIST_METRICS) {
      foreach my $tag (sort keys %TAGS) { print "<$tag>\t$TAGS{$tag}\n"; }
      return;
   }

   foreach my $tag (sort keys %TAGS) { $script->test_init($tag,$TAGS{$tag}); }

   if ($stderr ne '') {
      foreach my $tag (sort keys %TAGS) { $script->test_done($tag,'U'); }
      return;
   }

   my %cpu_user=();
   my %cpu_nice=();
   my %cpu_system=();
   my %cpu_iowait=();
   my %cpu_irq=();
   my %cpu_softirq=();
   my $interrupts=0;
   my ($ctx,$proc_total,$proc_run,$proc_block)=(0,0,0,0);
   my @lines = split (/\n/, $stdout);
   foreach my $l (@lines) {
      chomp;
		my @d=split(/\s/, $l);
		if ($d[0] =~ /cpu/) { 
			$cpu_user{$d[0]}=$d[1];
			$cpu_nice{$d[0]}=$d[2];
			$cpu_system{$d[0]}=$d[3];
			$cpu_iowait{$d[0]}=$d[4];
			$cpu_irq{$d[0]}=$d[5];
			$cpu_softirq{$d[0]}=$d[6];
		}
		elsif ($d[0] =~ /ctx/) { $ctx=$d[1]; }
		elsif ($d[0] =~ /processes/) { $proc_total=$d[1]; }
		elsif ($d[0] =~ /procs_running/) { $proc_run=$d[1]; }
		elsif ($d[0] =~ /procs_blocked/) { $proc_block=$d[1]; }
   }

   $script->test_done('012',\%cpu_user);
   $script->test_done('013',\%cpu_nice);
   $script->test_done('014',\%cpu_system);
   $script->test_done('015',\%cpu_iowait);
   $script->test_done('016',\%cpu_irq);
   $script->test_done('017',\%cpu_softirq);
   $script->test_done('018',$interrupts);
   $script->test_done('019',$ctx);
   $script->test_done('020',$proc_total);
   $script->test_done('021',$proc_run);
   $script->test_done('022',$proc_block);

}

#--------------------------------------------------------------------
# 'proc_net' => /bin/cat /proc/net/dev´'
#Inter-|   Receive                                                |  Transmit
# face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
#    lo:5609709936 21419944    0    0    0     0          0         0 5609709936 21419944    0    0    0     0       0          0
#  eth0:21727796944 53607037    0    0    0     0          0         0 6589856042 56474933    0    0    0     0       0          0
#

sub proc_net {
my ($script,$stdout, $stderr) = @_;

   my %TAGS=( '023'=>'Rx bytes', '024'=>'Rx packets', '025'=>'Rx errs', '026'=>'Rx drop', '027'=>'Rx fifo', '028'=>'Rx frame', '029'=>'Rx compressed', '030'=>'Rx multicast', '031'=>'Tx bytes', '032'=>'Tx packets', '033'=>'Tx errs', '034'=>'Tx drop', '035'=>'Tx fifo', '036'=>'Tx frame', '037'=>'Tx compressed', '038'=>'Tx multicast', '039'=>'Rx bits', '040'=>'Tx bits' );
   if ($LIST_METRICS) {
      foreach my $tag (sort keys %TAGS) { print "<$tag>\t$TAGS{$tag}\n"; }
      return;
   }

   foreach my $tag (sort keys %TAGS) { $script->test_init($tag,$TAGS{$tag}); }

   if ($stderr ne '') {
      foreach my $tag (sort keys %TAGS) { $script->test_done($tag,'U'); }
      return;
   }

   my %rxbytes=();
   my %rxpackets=();
   my %rxerrs=();
   my %rxdrop=();
   my %rxfifo=();
   my %rxframe=();
   my %rxcompressed=();
   my %rxmulticast=();
   my %txbytes=();
   my %txpackets=();
   my %txerrs=();
   my %txdrop=();
   my %txfifo=();
   my %txframe=();
   my %txcompressed=();
   my %txmulticast=();
   my %rxbits=();
   my %txbits=();

   my @lines = split (/\n/, $stdout);
#Inter-|   Receive                                                |  Transmit
# face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
#    lo:5609709936 21419944    0    0    0     0          0         0 5609709936 21419944    0    0    0     0       0          0
#  eth0:21727796944 53607037    0    0    0     0          0         0 6589856042 56474933    0    0    0     0       0          0
#

   foreach my $l (@lines) {
      chomp;
		if ($l=~/\|/) { next; }

 		# eth0: 19892276849 253519403    0    0    0     0          0         0 239501348523 31651689    0    0    0     0       0          0
      if ($l=~/^\s*(\S+)\:\s*(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)$/) {

#print "$l\n";

         my $iid=$1;
         $rxbytes{$iid}=$2; $rxpackets{$iid}=$3; $rxerrs{$iid}=$4; $rxdrop{$iid}=$5; $rxfifo{$iid}=$6; $rxframe{$iid}=$7; $rxcompressed{$iid}=$8; $rxmulticast{$iid}=$9;
         $txbytes{$iid}=$10; $txpackets{$iid}=$11; $txerrs{$iid}=$12; $txdrop{$iid}=$13; $txfifo{$iid}=$14; $txframe{$iid}=$15; $txcompressed{$iid}=$16; $txmulticast{$iid}=$17;
			$rxbits{$iid}=$rxbytes{$iid}*8;
			$txbits{$iid}=$txbytes{$iid}*8;
      }
   }

   $script->test_done('023',\%rxbytes);
   $script->test_done('024',\%rxpackets);
   $script->test_done('025',\%rxerrs);
   $script->test_done('026',\%rxdrop);
   $script->test_done('027',\%rxfifo);
   $script->test_done('028',\%rxframe);
   $script->test_done('029',\%rxcompressed);
   $script->test_done('030',\%rxmulticast);
   $script->test_done('031',\%txbytes);
   $script->test_done('032',\%txpackets);
   $script->test_done('033',\%txerrs);
   $script->test_done('034',\%txdrop);
   $script->test_done('035',\%txfifo);
   $script->test_done('036',\%txframe);
   $script->test_done('037',\%txcompressed);
   $script->test_done('038',\%txmulticast);
   $script->test_done('039',\%rxbits);
   $script->test_done('040',\%txbits);
}


#--------------------------------------------------------------------
# 'sys_net' => '/bin/grep "" /sys/class/net/*/*'
# El significado de losvalores esta en: 
# https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-class-net
#grep "" /sys/class/net/*/*
#/sys/class/net/eth0/address:c6:8a:28:d0:8d:30
#/sys/class/net/eth0/carrier:1
#/sys/class/net/eth0/dormant:0
#/sys/class/net/eth0/duplex:full
#/sys/class/net/eth0/iflink:2
#/sys/class/net/eth0/link_mode:0
#/sys/class/net/eth0/mtu:1500
#/sys/class/net/eth0/operstate:up
#/sys/class/net/eth0/speed:1000
#/sys/class/net/lo/carrier:1
#/sys/class/net/lo/dormant:0
#grep: /sys/class/net/lo/duplex: Invalid argument
#/sys/class/net/lo/iflink:1
#/sys/class/net/lo/link_mode:0
#/sys/class/net/lo/mtu:16436
#/sys/class/net/lo/operstate:unknown
#....
sub sys_net {
my ($script,$stdout, $stderr) = @_;

   my %TAGS=( '041'=>'operstate', '042'=>'mtu',  );
   if ($LIST_METRICS) {
      foreach my $tag (sort keys %TAGS) { print "<$tag>\t$TAGS{$tag}\n"; }
      return;
   }

   foreach my $tag (sort keys %TAGS) { $script->test_init($tag,$TAGS{$tag}); }

   if ($stderr ne '') {
      foreach my $tag (sort keys %TAGS) { $script->test_done($tag,'U'); }
      return;
   }

   my %operstate=();
   my %mtu=();

   my @lines = split (/\n/, $stdout);
#/sys/class/net/eth0/operstate:up

   foreach my $l (@lines) {
      chomp;

      if ($l=~/^\/sys\/class\/net\/(\S+)\/(\S+)\:(\S+)$/) { 
         my ($iid,$item,$value)=($1,$2,$3);
			if ($item=~/operstate/) { 
				# Segun RFC2863
				# "unknown", "notpresent", "down", "lowerlayerdown", "testing", "dormant", "up"
				my %num_value=('up'=>0, 'notpresent'=>1, 'down'=>2, 'unknown'=>3, 'lowerlayerdown'=>4, 'testing'=>5, 'dormant'=>6);
				$operstate{$iid} = (exists $num_value{$value}) ? $num_value{$value} : 3; 
			}
			elsif ($item=~/mtu/) { $mtu{$iid}=$value; }
      }
   }

   $script->test_done('041',\%operstate);
   $script->test_done('042',\%mtu);

}


#--------------------------------------------------------------------
# 'disk_size' => '/bin/df'
#Filesystem           1K-blocks      Used Available Use% Mounted on
#/dev/sda3             14418416  13010460    675540  96% /

#Filesystem            Inodes   IUsed   IFree IUse% Mounted on
#/dev/sda3             915712  219353  696359   24% /
#tmpfs                 257675       4  257671    1% /lib/init/rw


sub disk_size {
my ($script,$stdout, $stderr) = @_;

   my %TAGS=( '043'=>'Total 1K-blocks', '044'=>'Used', '045'=>'Available', '046'=>'Used (%)' );
   if ($LIST_METRICS) {
      foreach my $tag (sort keys %TAGS) { print "<$tag>\t$TAGS{$tag}\n"; }
      return;
   }

   foreach my $tag (sort keys %TAGS) { $script->test_init($tag,$TAGS{$tag}); }

   if ($stderr ne '') {
      foreach my $tag (sort keys %TAGS) { $script->test_done($tag,'U'); }
      return;
   }

   my %total=();
   my %used=();
   my %free=();
   my %totalp=();
   my @lines = split (/\n/, $stdout);
   foreach my $l (@lines) {
      chomp;
      if ($l=~/^\s*(\S+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)%\s+(.*)$/) {
         my $iid=$6;
         $total{$iid}=$2;
         $used{$iid}=$3;
         $free{$iid}=$4;
         $totalp{$iid}=$5;
      }
   }
   $script->test_done('043',\%total);
   $script->test_done('044',\%used);
   $script->test_done('045',\%free);
   $script->test_done('046',\%totalp);
}


