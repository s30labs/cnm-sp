<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_wmi_services.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este script permite obtener los procesos y servicios arrancados en el equipo. Un ejemplo de ejecución es:
cnm@cnm:/opt/cnm/xagent/base# ./linux_metric_wmi_services.pl -h
linux_metric_wmi_services.pl 1.0

linux_metric_wmi_services.pl -n IP -u user -p pwd [-d domain] [-i Name]
linux_metric_wmi_services.pl -n IP -u domain/user -p pwd [-i Name]
linux_metric_wmi_services.pl -h  : Ayuda

-n    IP remota
-u    user
-p    pwd
-d    Dominio
-i    Index Propiedad para indexar las instancias. Por defecto es Name.
-h    Ayuda

linux_metric_wmi_services.pl -n 1.1.1.1 -u user -p xxx
linux_metric_wmi_services.pl -n 1.1.1.1 -u user -p xxx -d miDominio
linux_metric_wmi_services.pl -n 1.1.1.1 -u user -p xxx -i Name
',
      );

?>
