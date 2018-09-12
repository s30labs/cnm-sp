#!/usr/bin/perl -w
BEGIN { $main::MYHEADER = <<MYHEADER;
#--------------------------------------------------------------------
# <CNMDOCU>
# NAME: cnm_backup_put.pl
# AUTHOR: Fernando Marin <fmarin\@s30labs.com>
# DATE: 27/01/2015
# VERSION: 1.0
#
# DESCRIPTION:
# Transfers CNM backup data to a remote host using ftp/sftp protocol.
# The credentials are specified in /cfg/ftpremote.conf or any file specified in the command line.
# cat /cfg/ftpremote.conf
# host
# user
# pwd
#
# USAGE:
# cnm_backup_put.pl 
# cnm_backup_put.pl [-file file_path] [-mode ftp|sftp]
# cnm_backup_put.pl -help 
#
# -help : Help
# -file : Remote credentials file
# -mode : Transfer mode (ftp|sftp). By default is sftp.
#
# cat /cfg/ftpremote.conf
# host
# user
# pwd
#
# </CNMDOCU>
#--------------------------------------------------------------------
MYHEADER
};
use lib "/opt/crawler/bin", "/opt/crawler/bin/support";
use strict;
use Getopt::Long;
use Data::Dumper;
use CNMScripts;
use Net::FTP;
use Net::SFTP::Foreign;

#-------------------------------------------------------------------------------------------
my $script = CNMScripts->new();
my %opts = ();
my $ok=GetOptions (\%opts,  'help','file=s','mode=s');
if (! $ok) {
   print STDERR "***ERROR EN EL PASO DE PARAMETROS***\n";
   $script->usage($main::MYHEADER);
   exit 1;
}

if ($opts{'help'}) { 
   $script->usage($main::MYHEADER);
   exit 0;
}

my $fconf = (!$opts{'file'}) ? '/cfg/ftpremote.conf' :  $opts{'file'};
if (!-f $fconf) { 
	print "File $fconf is missing ...\n"; 
	exit 2;
} 

my $mode = ($opts{'mode'}) ? $opts{'mode'} : 'sftp';

open (F,"<$fconf");
my @lines = <F>;
close F;
chomp $lines[0];
chomp $lines[1];
chomp $lines[2];

my $host = $lines[0];
my $user = $lines[1];
my $pwd = $lines[2];


print "Backup copy by $mode to $host ...\n";

if ($mode eq 'sftp') {

	my $sftp = Net::SFTP::Foreign->new("$user\@$host", password => $pwd, password_prompt => qr/\bpassword\:\s*$/);
	if ($sftp->error) {
  		print "sftp error: ".$sftp->error."\n";
		exit 2;
	}

	$sftp->put('/home/cnm/backup/cnm_backup.tar','cnm_backup.tar');
   if ($sftp->error) {
      print "sftp error: ".$sftp->error."\n";
		exit 2;
   }

	$sftp->disconnect;
}

else {

	my $ftp = Net::FTP->new($host, 'Timeout' => 10, 'Debug' => 0)  or die "Cannot connect to $host: $@";
	$ftp->login($user, $pwd)   or die "Cannot login ", $ftp->message;
	$ftp->put('/home/cnm/backup/cnm_backup.tar') or die "put failed ", $ftp->message;
	$ftp->quit;
}

