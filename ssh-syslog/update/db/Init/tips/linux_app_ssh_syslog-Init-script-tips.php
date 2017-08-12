<?php
      $TIPS[]=array(
         'id_ref' => 'linux_app_ssh_syslog.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este escript permite ejecutar uno o varios comandos por ssh y enviar el resultado obtenido por syslog utilizando la facility "local2". Sus parámetros de ejecución son:<br>
cnm@cnm:/opt/cnm/xagent/base# ./linux_app_ssh_syslog.pl -h
linux_app_ssh_syslog.pl 1.0

linux_app_ssh_syslog.pl -n IP -c nombre_credencial
linux_app_ssh_syslog.pl -n IP -c "-user=aaa -pwd=bbb" [-w xml] [-v]
linux_app_ssh_syslog.pl -h  : Ayuda

-n  IP remota/local
-c  Credenciales SSH
-x  Comando a ejecutar. Si hay varios, se pueden separar con &&.
-l  Se genera la salida para el syslog linea a linea. En caso contrario el resultado del comando se mete en una linea de syslog.
-w  Formato de salida (xml|txt)
-h  Ayuda
',
      );

?>
