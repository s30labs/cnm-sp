<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_vmware_vminfo.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este script permite obtener información sobre las máquinas virtuales definidas en el host ESX/ESXi a partir del API de vsSphere. Los parámetros del script son:
cnm@cnm:/opt/cnm/xagent/base# ./linux_metric_vmware_vminfo.pl -h
linux_metric_vmware_vminfo.pl 1.0

linux_metric_vmware_vminfo.pl -n IP -u user -p pwd [-P port]
linux_metric_vmware_vminfo.pl -h  : Ayuda

-n    IP remota (server)
-u    user
-p    pwd
-P    port      (Optional. Defaults 443)
-h    Ayuda

linux_metric_vmware_vminfo.pl -n 1.1.1.1 -u user -p xxx
linux_metric_vmware_vminfo.pl -n 1.1.1.1 -u user -p xxx -P 4443
',
      );

?>
