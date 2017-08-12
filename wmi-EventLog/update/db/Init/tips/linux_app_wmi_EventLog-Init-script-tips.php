<?php
      $TIPS[]=array(
         'id_ref' => 'linux_app_wmi_EventLog.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este escript permite obtener los registros del visor de eventos de WIndows mediante la clase WMI Win32_NTLogEvent. Sus parámetros de ejecución son:<br>
cnm@cnm:/opt/cnm/xagent/base# ./linux_app_wmi_EventLog.pl -h<br>
linux_app_wmi_EventLog.pl 1.0<br>
<br>
linux_app_wmi_EventLog.pl -n IP -u user -p pwd [-d domain] [-i index]<br>
linux_app_wmi_EventLog.pl -n IP -u domain/user -p pwd [-d domain] [-i index]<br>
linux_app_wmi_EventLog.pl -h  : Ayuda<br>
<br>
-n    IP remota<br>
-u    user<br>
-p    pwd<br>
-d    Dominio<br>
-i    Indice de busqueda. Valor del campo RecordNumber a pertir del cual se obtienen los datos<br>
',
      );

?>
