<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_www_yslow.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este script permite obtener las siguientes métricas al acceder a una determinada URL:

<001.http://www.s30labs.com> Overall Score <002.http://www.s30labs.com> Size (bytes) <003.http://www.s30labs.com> Page Load Time (ms) <004.http://www.s30labs.com> Number of requests

Sus parámetros de ejecución son:

 linux_metric_www_yslow.pl [-n 1.1.1.1] -u http://www.s30labs.com
 linux_metric_www_yslow.pl -l  : List metrics
 linux_metric_www_yslow.pl -h  : Ayuda

 -n          : IP remota
 -u          : URL
 -v/-verbose : Muestra informacion extra(debug)
 -h/-help    : Ayuda
 -l          : Lista las metricas que obtiene
',
      );

?>
