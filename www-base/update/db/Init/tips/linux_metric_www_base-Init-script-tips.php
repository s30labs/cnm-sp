<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_www_base.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este script permite obtener las siguientes métricas al acceder a una determinada URL:

<001.http://www.s30labs.com>    T (sgs)  <002.http://www.s30labs.com>    Size  <003.http://www.s30labs.com>    Num. ocurrencias de "xxxx" <004.http://www.s30labs.com>    Return Code Type  <005.http://www.s30labs.com>    Num. Links

Sus parámetros de ejecución son:

 linux_metric_www_base.pl -id 1
 linux_metric_www_base.pl -ip 86.109.126.250
 linux_metric_www_base.pl -n www -d s30labs.com
 linux_metric_www_base.pl -name www -domain s30labs.com
 linux_metric_www_base.pl -u http://www.s30labs.com -pattern cnm [-timeout 15]
 linux_metric_www_base.pl -u http://www.s30labs.com -l
 linux_metric_www_base.pl -h

 -id
      ID del dispositivo sobre el que se ejecuta el script. Los dispositivos deben tenere definido un campo URL de tipo listaa con las URLs a monitorizar.
 -n, -name
      Nombre del dispositivo sobre el que se ejecuta el script. Los dispositivos deben tenere definido un campo URL de tipo listaa con las URLs a monitorizar.
 -d, -domain
      Nombre del dispositivo sobre el que se ejecuta el script. Los dispositivos deben tenere definido un campo URL de tipo listaa con las URLs a monitorizar.
 -u, -url
      URL sobre la que se hace la peticion
 -pattern
      Patron de busqueda.  Contiene una cadena de texto que se busca dentro del contenido de la pagina.
 -timeout
      Timeout.  Por defecto 10 seg
 -v, -verbose
      Muestra informacion extra(debug)
 -h, -help
      Ayuda
 -l
      Lista las metricas que obtiene (es necesario especificar u,url,n o id)
',
      );

?>
