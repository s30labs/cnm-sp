<?php
      $TIPS[]=array(
         'id_ref' => 'cnm_backup_put.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este escript permite copiar el backup de CNM a un host remoto via ftp/sftp.Sus parametros de ejecución son:<b

cnm@cnm:/opt/cnm/xagent/base# ./cnm_backup_put.pl -help
cnm_backup_put.pl v1.0
(c)Fernando Marin <fmarin@s30labs.com> 27/01/2015

 cnm_backup_put.pl
 cnm_backup_put.pl [-file file_path] [-mode ftp|sftp]
 cnm_backup_put.pl -help

 -help : Help
 -file : Remote credentials file
 -mode : Transfer mode (ftp|sftp). By default is sftp.

 cat /cfg/ftpremote.conf
 host
 user
 pwd
',
      );

?>
