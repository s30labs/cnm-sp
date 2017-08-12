<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_vmware_performance.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este script permite obtener los valores de los contadores de Performance proporcionados por el API de vsSphere. El significado de sus parámetros es:
cnm@cnm:/opt/cnm/xagent/base# ./linux_metric_vmware_performance.pl -h
linux_metric_vmware_performance.pl 1.0

linux_metric_vmware_performance.pl -n IP -u user -p pwd [-H host_ame] [-P port]
linux_metric_vmware_performance.pl -h  : Ayuda

-n    IP remota (server)
-u    user
-p    pwd
-P    port      (Optional. Defaults 443)
-H    Host Name (Optional)
-s    Number of samples (Optional. Defaults 15)
-h    Ayuda

linux_metric_vmware_performance.pl -n 1.1.1.1 -u user -p xxx
linux_metric_vmware_performance.pl -n 1.1.1.1 -u user -p xxx -H myhost
linux_metric_vmware_performance.pl -n 1.1.1.1 -u user -p xxx -H myhost -P 4443
',
      );

?>
