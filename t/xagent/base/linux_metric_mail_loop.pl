#!/usr/bin/perl -w
#--------------------------------------------------------------------------------------
# linux_metric_mail_loop.pl
# Obtiene el tiempo en segs. que se tarda en hacer un bucle de correo.
# PARAMETROS:
# a. mxhost : IP/nombre del servidor SMTP que se va a utilizar como relay
# b. from : Direccion de correo desde la que se realiza el envio. Habitualmente el nombre de
# 				usuario debera estar definido en el servidor SMTP y por otra parte solo hara relay 
# 				de sus dominios por lo que debe ser necesariamente un parametro
# c. to :	Direccion destino del correo, donde esta implementada la regla de retransmision del correo
# -------------------------------------------------
# Si el correo se redirige de nuevo al CNM:
#
# -------------------------------------------------
# Para descarga por POP3
# d. pop3host:	IP/nombre del servidor POP3 donde esta el buzon del usuario
# e. username:	Usuario para conectarse al buzon POP3
# f. password:	Clave de dicho usuario
# -------------------------------------------------
# a. IP remota
# b. Puerto remoto
# linux_metric_mail_loop.pl 1.1.1.1 443
#--------------------------------------------------------------------------------------
use strict;
use Net::SMTP;
use Net::SMTP::TLS;
#use Net::POP3;
use Mail::POP3Client;
use Time::HiRes qw(gettimeofday tv_interval);
use Getopt::Long;

#--------------------------------------------------------------------------------------
# Parametros SMTP
#my $mxhost='213.186.47.112';
#my $from='cnmloop@s30labs.com';
#my $to='fmarinla@gmail.com';

#--------------------------------------------------------------------------------------
#Parametros POP
#my $pop3host='213.186.47.112';
#my $username='cnmloops30';
#my $password='gcyr69';

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
# Informacion ------------------------------------------------------
my @fpth = split ('/',$0,10);
my @fname = split ('\.',$fpth[$#fpth],10);
my $USAGE = <<USAGE;
(c) s30labs by fml

$fpth[$#fpth] -h : Ayuda
$fpth[$#fpth] -mxhost=1.1.1.1 -mxport=25 -to=pp\@pp.com -from=jj\@jj.com -pop3host=2.2.2.2 -pop3port=110 -user=pp -pwd=1234
$fpth[$#fpth] -tls -mxhost=1.1.1.1 -mxport=465 -to=pp\@pp.com -from=jj\@jj.com -pop3host=2.2.2.2 -pop3port=995 -user=pp -pwd=1234
$fpth[$#fpth] -tlsa -txuser=aa -txpwd=bb -mxhost=1.1.1.1 -mxport=465 -to=pp\@pp.com -from=jj\@jj.com -pop3host=2.2.2.2 -pop3port=995  -user=pp -pwd=1234

-h (-help): Ayuda
-v (-verbose): verbose

-mxhost: Host SMTP
-mxport: Puerto SMTP
-to:     Campo to del correo
-from:   Campo from del correo
-txuser: Usuario SMTP (Si es SMTP Autenticado)
-txpwd:	Clave del usuario SMTP (Si es SMTP Autenticado)
-tls:		Si se especifica, indica que el envio es con TLS
-tlsa:	Si se especifica, indica que el envio es con TLS + AUTH

-pop3host: Host POP3
-pop3port: Puerto POP3
-user:   Usuario POP3
-pwd:    Clave del usuario POP3

-n:      Numero de correos que se envian
USAGE


my %OPTS = ();
GetOptions (\%OPTS,  'h','help','v','verbose','tls','tlsa','txuser=s','txpwd=s','mxhost=s','mxport=s','to=s','from=s','pop3host=s','pop3port=s','user=s','pwd=s','n=s')
            or die "$0:[ERROR] en el paso de parametros. Si necesita ayuda ejecute $0 -help\n";


if ( ($OPTS{'help'}) || ($OPTS{'h'}) ) { die $USAGE; }
#if (! $OPTS{'page'}) { die $USAGE; }
#else { $DESC{'page'}=$OPTS{'page'}; }
#--------------------------------------------------------------------------------------
# Parametros SMTP
my $mxhost=$OPTS{'mxhost'} || die $USAGE;
my $mxport=$OPTS{'mxport'} || '25';
my $from=$OPTS{'from'} || die $USAGE;
my $to=$OPTS{'to'} || die $USAGE;

my ($tls,$txuser,$txpwd)=(0,'','');
if ($OPTS{'tls'}){
	$tls=1;
}
elsif ($OPTS{'tlsa'}){
   $tls=1;
   $txuser=$OPTS{'txuser'} || die $USAGE;
   $txpwd=$OPTS{'txpwd'} || die $USAGE;
}

#--------------------------------------------------------------------------------------
#Parametros POP
my $pop3host=$OPTS{'pop3host'};
my $pop3port=$OPTS{'pop3port'} || '110';
my $username=$OPTS{'user'};
my $password=$OPTS{'pwd'};

#--------------------------------------------------------------------------------------
my $NUM_MAILS=$OPTS{'n'} || 3;
my $SUBJECT= '[linux_metric_mail_loop] Bucle de correo';
my $SUBJECT_QUOTED= quotemeta($SUBJECT);

#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------

	my $LOGGER='/usr/bin/logger -p local0.info';

   my ($mail_send_cnt,$mail_recv_cnt,$elapsed_send,$elapsed_recv)=(0,0,'U','U');

	($mail_send_cnt,$elapsed_send) = tx_mail_by_smtp($tls,$txuser,$txpwd,$mxhost,$mxport,$to,$from,$SUBJECT);

	if ((defined $OPTS{'pop3host'}) && (defined $OPTS{'user'}) && (defined $OPTS{'pwd'})) {
		($mail_recv_cnt,$elapsed_recv) = rx_mail_by_pop3($pop3host,$pop3port,$username,$password);
	}

	print "<001> Correos Enviados = $mail_send_cnt\n";
	print "<002> Correos Recibidos = $mail_recv_cnt\n";
	print "<003> Tiempo de Transmision = $elapsed_send\n";
	print "<004> Tiempo de Recepcion = $elapsed_recv\n";





#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------



#--------------------------------------------------------------------------------------
# tx_mail_by_smtp
#--------------------------------------------------------------------------------------
sub tx_mail_by_smtp {
my ($tls,$txuser,$txpwd,$mxhost,$mxport,$to,$from,$subject) = @_;

	my $smtp;
	my $ts=time();
	my $subject_custom="$subject ($ts)";
#------------------------------------------------
# Return-path: Es el MAIL FROM
# Envelope-to: Es el RCPT TO
my $MAIL_TO_SEND = <<"EOFMAIL";
Return-path: <$from>
Envelope-to: $to
Delivery-date: Tue, 23 Mar 2010 17:23:39 +0100
Received: from [188.18.202.158] (helo=adam.es)
   by ks30588.kimsufi.com with smtp (Exim 4.63)
   (envelope-from <$from>)
   id 1Nu6tD-00075g-EM
   for $to; Tue, 23 Mar 2010 17:23:39 +0100
From:  <$from>
To: $to
Subject: $subject_custom
MIME-Version: 1.0
Content-Type: text/html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=iso-8859-2">
</HEAD>
<BODY>
ESTE CORREO SOLO SIRVE PARA PODER VERIFICAR EL CORRECTO FUNCIONAMIENTO DE LA INFRAESTRUCTURA DE CORREO.
</BODY>
</HTML>
EOFMAIL
#------------------------------------------------

	my $t0 = [gettimeofday];
	my ($mail_send_cnt,$elapsed_send)=(0,'U');

	if ($tls) {
		$smtp = new Net::SMTP::TLS( $mxhost, Hello => '', Port => $mxport, User => $txuser, Password => $txpwd );
	}
	else {
   	$smtp = Net::SMTP->new($mxhost, Timeout => 60);
	}

   if (!defined $smtp) {
		system ("$LOGGER $0 [ERROR] al crear objeto SMTP $mxhost");
		return ($mail_send_cnt,$elapsed_send);
   }

	while ($NUM_MAILS>0) {

		# CON TLS
		if ($tls) {

			eval {
	         $smtp->mail($from);
				system ("$LOGGER \"$0: SMTP-TLS MAIL FROM:$from\"");
      	   $smtp->to($to);
				system ("$LOGGER \"$0: SMTP-TLS RCPT TO:$to\"");

	         $smtp->data;
   	      $smtp->datasend($MAIL_TO_SEND);
      	   $smtp->dataend;
	
				system ("$LOGGER \"$0: SMTP-TLS ($subject) DATA\"");
				$mail_send_cnt+=1;
	      };
   	   if ($@) {
				system ("$LOGGER \"$0: SMTP-TLS ERROR ($@)\"");
				return ($mail_send_cnt,$elapsed_send);
      	}

		}

		# SIN TLS
		else {
		   $smtp->mail($from);
			my $code=$smtp->code();
			my $msg=$smtp->message();	
   		$msg=~s/[\n|\>|\<]/ /g;
			system ("$LOGGER \"$0: SMTP MAIL FROM:$from ($code) RESP: $msg\"");
   		if ($smtp->code() > 500) {
      		$smtp->quit;
				return ($mail_send_cnt,$elapsed_send);
   		}

		   $smtp->to($to);
   		$code=$smtp->code();
	   	$msg=$smtp->message();
   		$msg=~s/[\n|\>|\<]/ /g;
	   	system ("$LOGGER \"$0: SMTP RCPT TO:$to ($code) RESP: $msg\"");
		   if ($smtp->code() > 500) {
   		   $smtp->quit;
				return ($mail_send_cnt,$elapsed_send);
   		}

		   $smtp->data([$MAIL_TO_SEND]);
   		$code=$smtp->code();
	   	$msg=$smtp->message();
   		$msg=~s/[\n|\>|\<]/ /g;
   		system ("$LOGGER \"$0: SMTP DATA ($code) RESP: $msg (SUBJECT=$subject_custom)\"");
	
   		if ($smtp->code() > 500) {
				system ("$LOGGER \"$0: ERROR DE MTA ($code) RESP: $msg\"");
	     	 	$smtp->quit;
				return ($mail_send_cnt,$elapsed_send);
	   	}
			else { $mail_send_cnt+=1; }

		}




		$NUM_MAILS -=1;
	}

   $smtp->quit;


  	my $elapsed = tv_interval ( $t0, [gettimeofday]);
   $elapsed_send = sprintf("%.6f", $elapsed);
	return ($mail_send_cnt,$elapsed_send);

}


#-----------------------------------------------------------------------------------
# rx_mail_by_host
#-----------------------------------------------------------------------------------
sub rx_mail_by_proxy {
my ($username, $password) = @_;

   my $t0 = [gettimeofday];
   my ($mail_recv_cnt,$elapsed_recv)=(0,'U');

   my $MAIL_INBOX="/opt/data/buzones/$username/new/";
   opendir (DIR,$MAIL_INBOX);
   my @mail_files = readdir(DIR);
   closedir(DIR);

   if (scalar(@mail_files)==0) {
		return ($mail_recv_cnt,$elapsed_recv);
  	}

   my $mail_loop=0;
   foreach my $file (sort @mail_files) {

      my $file_path=$MAIL_INBOX.$file;
      if (! -f $file_path) { next; }

		open (F, "<$file_path");
		while (<F>) {
			chomp;
         if (/Subject\:\s*$SUBJECT_QUOTED/) {
            $mail_loop=1;
            system ("$LOGGER \"$0: RX MAIL: MATCH SUBJECT=$_\"");
         }
		}
      if ($mail_loop) {
         $mail_recv_cnt +=1;
			unlink $file_path;
      }
	}

   my $elapsed = tv_interval ( $t0, [gettimeofday]);
   $elapsed_recv = sprintf("%.6f", $elapsed);
   return ($mail_recv_cnt,$elapsed_recv);

}



#-----------------------------------------------------------------------------------
# rx_mail_by_pop3
#-----------------------------------------------------------------------------------
sub rx_mail_by_pop3 {
my ($pop3host,$pop3port,$username, $password) = @_;

	
	my $t0 = [gettimeofday];
	my ($mail_recv_cnt,$elapsed_recv)=(0,'U');

	#my $port='995';
	my $pop = Mail::POP3Client->new(HOST => $pop3host, PORT => $pop3port, USESSL =>1);

	$pop->User($username);
	$pop->Pass($password);
	my $rc = $pop->Connect();
	if (! $rc) {
		my $msg=$pop->Message;
      system ("$LOGGER \"$0: POP3: ERROR EN LOGIN HOST=$pop3host PORT=$pop3port username=$username\"");
      return ($mail_recv_cnt,$elapsed_recv);
   }

   my $mvector = $pop->ListArray; # hashref of msgnum => size
	my @mv=split (/\n/,$mvector);
	my @msgs=();
	foreach my $m (@mv) {
		my ($n,$size) = split (/\s+/,$m);
		push @msgs,$n;
	}
#	my @msgs=();
#	my $c=0;
#	foreach my $n (@$msgvector) {
#		if ($c % 2 == 0) { push @msgs,$n; }
#		$c +=1;
#	}

   #my $num = scalar(keys %$msgnums);
	my $num = scalar(@msgs);
   system ("$LOGGER \"$0: POP3: HOST=$pop3host username=$username MSGS=$num\"");

   #foreach my $msgnum (keys %$msgnums) {
   foreach my $msgnum (@msgs) {
      my $msg = $pop->Retrieve($msgnum);
		if ($msg=~/Subject\:\s*$SUBJECT_QUOTED/g) {
         system ("$LOGGER \"$0: POP3: MATCH SUBJECT=$SUBJECT_QUOTED\"");
			$mail_recv_cnt +=1;
			$pop->Delete($msgnum);
      }
      


#      foreach my $l (@$msg) {
#         if ($l=~/Subject\:\s*$SUBJECT_QUOTED/) {
#            $mail_loop=1;
#            system ("$LOGGER \"$0: POP3: MATCH SUBJECT=$l\"");
#         }
#      }

#      if ($mail_loop) {
#         $mail_recv_cnt +=1;
#         #print "MSGNUM=$msgnum\n";
#         #print @$msg;
#         $pop->Delete($msgnum);
#      }

  }

   #$pop->quit;
   $pop->Close;





#   my $pop = Net::POP3->new($pop3host, PeerPort => $port, Timeout => 60);
#
#   my $rc=$pop->login($username, $password);
#
#   if (!defined $rc) {
#      system ("$LOGGER \"$0: POP3: ERROR EN LOGIN HOST=$pop3host username=$username\"");
#		return ($mail_recv_cnt,$elapsed_recv);
#   }
#
#   my $msgnums = $pop->list; # hashref of msgnum => size
#   my $num = scalar(keys %$msgnums);
#   system ("$LOGGER \"$0: POP3: HOST=$pop3host username=$username MSGS=$num\"");
#
#   foreach my $msgnum (keys %$msgnums) {
#      my $msg = $pop->get($msgnum);
#      my $mail_loop=0;
#      foreach my $l (@$msg) {
#         if ($l=~/Subject\:\s*$SUBJECT_QUOTED/) { 
#				$mail_loop=1; 
#				system ("$LOGGER \"$0: POP3: MATCH SUBJECT=$l\"");
#			}
#		}
#      if ($mail_loop) {
#         $mail_recv_cnt +=1;
#         #print "MSGNUM=$msgnum\n";
#         #print @$msg;
#         $pop->delete($msgnum);
#      }
#   }
#
#   $pop->quit;

   my $elapsed = tv_interval ( $t0, [gettimeofday]);
   $elapsed_recv = sprintf("%.6f", $elapsed);
	return ($mail_recv_cnt,$elapsed_recv);

}
