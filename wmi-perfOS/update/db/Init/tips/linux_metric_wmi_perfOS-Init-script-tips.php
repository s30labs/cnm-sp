<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_wmi_perfOS.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este script permite obtener valores de performance de un equipo con SO Windows a partir de diferentes clases WMI (Win32_PerfFormattedData_PerfOS_Cache, Win32_PerfFormattedData_PerfOS_Memory, Win32_PerfFormattedData_PerfOS_Processor, Win32_PerfFormattedData_PerfOS_PagingFile o Win32_PerfFormattedData_PerfOS_System).Sus parámetros de ejecución son:
root@cnm-devel:/opt/cnm/xagent/base# ./linux_metric_wmi_perfOS.pl -h
linux_metric_wmi_perfOS.pl 1.0

linux_metric_wmi_perfOS.pl -n IP -u user -p pwd [-d domain]
linux_metric_wmi_perfOS.pl -n IP -u domain/user -p pwd
linux_metric_wmi_perfOS.pl -h  : Ayuda

-n    IP remota
-u    user
-p    pwd
-d    Dominio
',
      );

?>
