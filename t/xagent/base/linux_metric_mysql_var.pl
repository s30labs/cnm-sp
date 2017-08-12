#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# NAME:	linux_metric_mysql_var.pl
#
# DESCRIPTION:
# Obtiene los valores de los diferentes parametros de estado de la BBDD MySQL.
#
# CALLING SAMPLE:
# ./linux_metric_mysql_var.pl -user user12 -pwd xxxx -host localhost
#
# INPUT (PARAMS):
# a. -user	:	Usuario de la BBDD MySQL
# b. -pwd	:	Clave de acceso del ausuario a la BBDD MySQL
# c. -host	:	Host donde esta la BBDD
# p. -port	:	Puerto TCP abierto por la BBDD MySQL (default 3306)
#
# OUTPUT (STDOUT):
# <001> buffer_used = 0.11
# <002> read_hits = 99.97
# <003> write_hits = 47.05
# <004> connections = 13.33
#
# OUTPUT (STDERR):
# Error info, warnings etc... If verbose also debug info.
#
# EXIT CODE:
#  0:	OK
# -1:	System error
# >0: Script error
#--------------------------------------------------------------------------------------
use strict;
use Time::Local;
use DBI;
use Data::Dumper;
use Getopt::Long;

#--------------------------------------------------------------------------------------
my $ERR=0;
my $ERRSTR='';
my $VERBOSE=0;

#--------------------------------------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $USAGE = <<USAGE;
(c) s30labs by fml

$fpth[$#fpth] -h : Ayuda
$fpth[$#fpth] -user=db_user -pwd=1234 --port=3306 -host=ip -metric=nombre_metrica
$fpth[$#fpth] -l
$fpth[$#fpth] -list

-v:      Verbose
-h (-help): Ayuda
-l:		Lista las metricas definidas
-list:	Lista las metricas definidas

-user: 	Usuario mysql
-pwd:    Clave del usuario
-port:   Puerto
-host 	Servidor de BBDD
USAGE

#--------------------------------------------------------------------------------------
# Metricas soportadas
my %METRICS = (
   '<001> buffer_used'  	=> '',
   '<002> read_hits'    	=> '',
   '<003> write_hits'    	=> '',
   '<004> connections'  	=> '',
);

#--------------------------------------------------------------------------------------
my %OPTS = ();
GetOptions (\%OPTS,  'h','help','v','verbose','l','list','user=s','pwd=s','host=s','port=s','metric=s')
            or die "$0:[ERROR] en el paso de parametros. Si necesita ayuda ejecute $0 -help\n";


if ( ($OPTS{'help'}) || ($OPTS{'h'}) ) { die $USAGE; }
if ( ($OPTS{'verbose'}) || ($OPTS{'v'}) ) { $VERBOSE=1; }
if ( ($OPTS{'list'}) || ($OPTS{'l'}) ) { 
	foreach my $m (sort keys %METRICS) { print "$m\n"; }
	exit 0;
}
#--------------------------------------------------------------------------------------
my %DB = (
        DRIVERNAME => "mysql",
        SERVER => "",
        PORT => 3306,
        DATABASE => "",
        USER => "",
        PASSWORD => "",
        TABLE => '',
);

$DB{'SERVER'} = $OPTS{'host'} || die $USAGE;
$DB{'PORT'} = $OPTS{'port'} || '3306';
$DB{'USER'} = $OPTS{'user'} || die $USAGE;
$DB{'PASSWORD'} = $OPTS{'pwd'} || die $USAGE;
my $metric_name = $OPTS{'metric'} || 'ALL';

if ( (uc $metric_name ne 'ALL') && (! exists $METRICS{$metric_name})) { 
	print STDERR "No existe la metrica especificada ($metric_name)\n";
	print STDERR "Las metricas definidas son:\n";
	foreach my $m (sort keys %METRICS) { print STDERR "$m\n"; }
	exit 1;
}
#print Dumper(\%DB);
#--------------------------------------------------------------------------------------
my $r=`/sbin/ifconfig eth0`;
$r=~/inet\s+addr\:(\d+\.\d+\.\d+\.\d+)\s+/;
if ($1 eq $DB{'SERVER'}) { $DB{'SERVER'} = 'localhost'; }

#--------------------------------------------------------------------------------------
my $DBH=sqlConnect(\%DB);
if (! defined $DBH) {
   print STDERR "ERROR en conexion a BBDD\n";
   exit 2;
}

my $status=sqlSelectAll($DBH,"SHOW status", 'Variable_name' );
my $vars=sqlSelectAll($DBH,"SHOW variables", 'Variable_name' );
sqlDisconnect($DBH);

if ($ERR) {
	print STDERR "ERROR: $ERR\n"; 
	exit 3;	
}

#--------------------------------------------------------------------------------------
#print Dumper($status);

#--------------------------------------------------------------------------------------
# <001> buffer_used
#--------------------------------------------------------------------------------------

	my $buffer_used_raw = 100*($status->{'Key_blocks_used'}->{'Value'}*$vars->{'key_cache_block_size'}->{'Value'})/$vars->{'key_buffer_size'}->{'Value'};
	$METRICS{'<001> buffer_used'} = sprintf ("%.2f",$buffer_used_raw);

	if ($VERBOSE) {
		print STDERR 'Key_blocks_used: '.$status->{'Key_blocks_used'}->{'Value'}."\n";
		print STDERR 'key_cache_block_size: '.$vars->{'key_cache_block_size'}->{'Value'}."\n";
		print STDERR 'key_buffer_size: '.$vars->{'key_buffer_size'}->{'Value'}."\n";

		print STDERR '***Buffer Used (%) [buffer_used]: ' . $METRICS{'<001> buffer_used'} ."\n";
	}


#--------------------------------------------------------------------------------------
# <002> read_hits
# <003> write_hits
#--------------------------------------------------------------------------------------
	my $read_hits_raw = 100;
	if ($status->{'Key_reads'}->{'Value'} != 0) {
      $read_hits_raw = 100 - ($status->{'Key_reads'}->{'Value'}/$status->{'Key_read_requests'}->{'Value'})*100;
   }
	my $read_hits_formatted = sprintf ("%.2f",$read_hits_raw);
		
	if ($VERBOSE) {
		print STDERR 'Key_read_requests: '.$status->{'Key_read_requests'}->{'Value'}."\n";
		print STDERR 'Key_reads: '.$status->{'Key_reads'}->{'Value'}."\n";
		print STDERR '***Read Hits (%) [read_hits]: ' . $read_hits_formatted ."\n";
	}


   my $write_hits_raw = 100;
   if ($status->{'Key_writes'}->{'Value'} != 0) {
      $write_hits_raw = 100 - ($status->{'Key_writes'}->{'Value'}/$status->{'Key_write_requests'}->{'Value'})*100;
   }
   my $write_hits_formatted = sprintf ("%.2f",$write_hits_raw);

   if ($VERBOSE) {
      print STDERR 'Key_write_requests: '.$status->{'Key_write_requests'}->{'Value'}."\n";
      print STDERR 'Key_writes: '.$status->{'Key_writes'}->{'Value'}."\n";
      print STDERR '***Write Hits (%) [write_hits]: ' . $write_hits_formatted ."\n";
   }

	$METRICS{'<002> read_hits'}=$read_hits_formatted;
	$METRICS{'<003> write_hits'}=$write_hits_formatted;

#--------------------------------------------------------------------------------------
# <004> connections
#--------------------------------------------------------------------------------------
	my $connections = 100*$status->{'Max_used_connections'}->{'Value'}/$vars->{'max_connections'}->{'Value'};
	$METRICS{'<004> connections'} = sprintf ("%.2f",$connections);
	if ($VERBOSE) {
		print STDERR 'max_connections: '.$vars->{'max_connections'}->{'Value'}."\n";
		print STDERR 'Max_used_connections: '.$status->{'Max_used_connections'}->{'Value'}."\n";
		print STDERR '***Connections (%) [connections]: ' . sprintf ("%.2f",$connections)."\n";
	}

#--------------------------------------------------------------------------------------
# Genero la salida
if (uc $metric_name eq 'ALL') {
	foreach my $m (sort keys %METRICS) { print "$m = $METRICS{$m}\n"; }
}
else {
	print "$metric_name = $METRICS{$metric_name}\n";
}

exit 0;



#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
# AUXILIARY FUNCTIONS
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
sub sqlConnect
{
my $db=shift;
my $dbh=undef;

   my $dsn = "DBI:mysql:database=$$db{DATABASE};host=$$db{SERVER};port=$$db{PORT};mysql_connect_timeout=5";

   eval {
      $dbh = DBI->connect($dsn,$$db{USER},$$db{PASSWORD},{PrintError => 1,RaiseError => 1,AutoCommit => 0}) ;
      $ERRSTR=$DBI::errstr;
      $ERR=$DBI::err;
   };

   return $dbh;
}

#--------------------------------------------------------------------------------------
sub sqlDisconnect
{
my $dbh=shift;

	my $rc=$dbh->disconnect;
}


#--------------------------------------------------------------------------------------
sub sqlSelectAll
{
my ($dbh, $sql, $key_val)=@_;
my $H=undef;

	eval {
		if ($key_val ne '') {
	   	$H=$dbh->selectall_hashref($sql, $key_val);
		}
		else {
			$H=$dbh->selectall_arrayref($sql);
		}

	};

	if ($@) {

   	$ERRSTR=$DBI::errstr;
   	$ERR=$DBI::err;
	}

	return $H;

}



