<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_wmi_process.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este script permite obtener el numero de procesos en ejecucion en un equipo Win32. Un ejemplo de ejecución es:
cnm@cnm:/opt/cnm/xagent/base# ./linux_metric_wmi_process.pl -h
linux_metric_wmi_process.pl 1.0

linux_metric_wmi_process.pl -n IP -u user -p pwd [-d domain]
linux_metric_wmi_process.pl -n IP -u domain/user -p pwd
linux_metric_wmi_process.pl -h  : Ayuda

-n    IP remota
-u    user
-p    pwd
-d    Dominio
-i    Nombre del proceso
-h    Ayuda

linux_metric_wmi_process.pl -n 1.1.1.1 -u user -p xxx
linux_metric_wmi_process.pl -n 1.1.1.1 -u user -p xxx -d miDominio
',
      );

?>
