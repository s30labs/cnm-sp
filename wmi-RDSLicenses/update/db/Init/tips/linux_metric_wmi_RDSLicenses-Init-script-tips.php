<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_wmi_RDSLicenses.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este script permite obtener metricas relativas a las licencias asignadas por un servidor RDS en un equipo con SO Windows a partir de la clase WMI (Win32_TSIssued_License). Sus parámetros de ejecución son:
root@cnm-devel:/opt/cnm/xagent/base# ./linux_metric_wmi_RDSLicenses.pl -h
linux_metric_wmi_RDSLicenses.pl 1.0

linux_metric_wmi_RDSLicenses.pl -n IP -u user -p pwd [-d domain]
linux_metric_wmi_RDSLicenses.pl -n IP -u domain/user -p pwd
linux_metric_wmi_RDSLicenses.pl -h  : Ayuda

-n    IP remota
-u    user
-p    pwd
-d    Dominio
',
      );

?>
