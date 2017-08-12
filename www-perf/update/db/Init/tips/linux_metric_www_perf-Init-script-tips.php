<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_www_perf.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este script permite obtener las siguientes métricas al acceder a una determinada URL:

<001.http://www.s30labs.com> Total Time (sg) <002.http://www.s30labs.com> Wait Time (sg) <003.http://www.s30labs.com> Receive Time (sg) <004.http://www.s30labs.com> Connect Time (sg) <005.http://www.s30labs.com> Blocked Time (sg) <006.http://www.s30labs.com> DNS Time (sg) <007.http://www.s30labs.com> Send Time (sg) <008.http://www.s30labs.com> SSL Time (sg) <009.http://www.s30labs.com> Other Time (sg) <010.http://www.s30labs.com> Responses with code 200 <011.http://www.s30labs.com> Responses with codes 4x <012.http://www.s30labs.com> Responses with codes 5x <013.http://www.s30labs.com> Response with other codes <020.http://www.s30labs.com> Total Requests Counter <021.http://www.s30labs.com> Html Requests Counter <022.http://www.s30labs.com> Javascript Requests Counter <023.http://www.s30labs.com> CSS Requests Counter <024.http://www.s30labs.com> Image Requests Counter <025.http://www.s30labs.com> Text Requests Counter <026.http://www.s30labs.com> Other Requests Counter <030.http://www.s30labs.com> Total Requests Size (bytes) <031.http://www.s30labs.com> Html Requests Size (bytes) <032.http://www.s30labs.com> Javascript Requests Size (bytes) <033.http://www.s30labs.com> CSS Requests Size (bytes) <034.http://www.s30labs.com> Image Requests Size (bytes) <035.http://www.s30labs.com> Text Requests Size (bytes) <036.http://www.s30labs.com> Other Requests Size (bytes)
 
Sus parámetros de ejecución son:

 linux_metric_www_perf.pl [-n 1.1.1.1] -u http://www.s30labs.com
 linux_metric_www_perf.pl -l  : List metrics
 linux_metric_www_perf.pl -h  : Ayuda

 -n          : IP remota
 -u          : URL
 -v/-verbose : Muestra informacion extra(debug)
 -h/-help    : Ayuda
 -l          : Lista las metricas que obtiene
',
      );

?>
