<?php
      $TIPS[]=array(
         'id_ref' => 'linux_app_wmi_class.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este script permite obtener los valores de las propiedades soportadas por la clase WMI especificada. Un ejemplo de ejecución es:<br>
cnm@cnm:/opt/cnm/xagent/base# ./linux_app_wmi_class.pl -h<br>
linux_app_wmi_class.pl 1.0<br>
<br>
linux_app_wmi_class.pl -n IP -u user -p pwd [-d domain] -c class [-i index] [-a "root\CIMV2"]<br>
linux_app_wmi_class.pl -n IP -u domain/user -p pwd -c class [-i index]<br>
linux_app_wmi_class.pl -h  : Ayuda<br>
<br>
-n    IP remota<br>
-u    user<br>
-p    pwd<br>
-d    Dominio<br>
-v    Verbose<br>
-c    Clase wmi (Win32_Service ...)<br>
-i    Indice (iid) para la Clase wmi (Si aplica)<br>
-a    Namespace (si es distinto de root\CIMV2)<br>
',
      );

?>
