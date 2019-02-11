<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_ssh_docker.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este script permite obtener las siguientes métricas de un equip ocon Docker:

<001> Running Containers <002> RIP Containers <003> Other Containers

Sus parámetros de ejecución son:

 linux_metric_ssh_docker.pl -n 1.1.1.1 [-port 2322]
 linux_metric_ssh_docker.pl -n 1.1.1.1 -user=aaa -pwd=bbb
 linux_metric_ssh_docker.pl -n 1.1.1.1 -user=aaa -key_file=/etc/ssh/id_rsa
 linux_metric_ssh_docker.pl -n 1.1.1.1 -user=aaa -key_file=1
 linux_metric_ssh_docker.pl -h  : Ayuda

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
