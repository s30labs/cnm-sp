<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_mail_mbox.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este script permite validar el acceso a un buzon de correo por PO o IMAP. Sus parámetros de ejecución son:

cnm@cnm:/opt/cnm-sp/tcp_check/xagent/base# ./linux_metric_mail_mbox.pl
linux_metric_mail_mbox.pl. 1.0

linux_metric_mail_mbox.pl -host outlook.office365.com -port 995 -proto imap -ssl -user user\@domain.com -pwd xxx
linux_metric_mail_mbox.pl -host outlook.office365.com -port 993 -proto pop -ssl -user user\@domain.com -pwd xxx
linux_metric_mail_mbox.pl -h  : Ayuda

-host       : POP/IMAP Server Host
-proto      : imap/pop protocol (default imap)
-port       : Port (default 993 - imaps)
-user       : User
-pwd        : Password
-ssl        : If set uses SSL protocol
-mailbox    : User mailbox (default INBOX)
-timeout    : Connection timeout (default 2)
-v/-verbose : Verbose output (debug)
-h/-help    : Help
',
      );

?>
