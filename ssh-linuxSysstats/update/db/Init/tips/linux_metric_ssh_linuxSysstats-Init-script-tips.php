<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_ssh_linuxSysstats.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este script permite obtener los datos proporcionados por los contadores de rendimiento syssyats para un SO unix/Linux.

Sus parámetros de ejecución son:

 linux_metric_ssh_linuxSysstats.pl -n 1.1.1.1 [-port 2322]
 linux_metric_ssh_linuxSysstats.pl -n 1.1.1.1 -user=aaa -pwd=bbb
 linux_metric_ssh_linuxSysstats.pl -n 1.1.1.1 -user=aaa -key_file=/etc/ssh/id_rsa
 linux_metric_ssh_linuxSysstats.pl -n 1.1.1.1 -user=aaa -key_file=1
 linux_metric_ssh_linuxSysstats.pl -h  : Ayuda

 -n          : IP remota
 -port       : Puerto
 -user       : Usuario
 -pwd        : Clave
 -passphrase : Passphrase SSH
 -key_file   : Fichero con la clave publica (Si vale 1 indica que ua el ficheo estandar de CNM)
 -v/-verbose : Muestra informacion extra(debug)
 -h/-help    : Ayuda
 -l          : Lista las metricas que obtiene
',
      );

?>
