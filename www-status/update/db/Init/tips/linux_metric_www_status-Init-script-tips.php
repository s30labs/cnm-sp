<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_www_status.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este script permite obtener el estado de una URL en base a criterios de mantenimiento y de OK o Error especificados

<000.http://www.s30labs.com> RC = 0
<001.http://www.s30labs.com> T (sgs) = 0.064599
<002.http://www.s30labs.com> Size = 194
<003.http://www.s30labs.com> Status = 1
<004.http://www.s30labs.com> Return Code Type = 2
<005.http://www.s30labs.com> Num. Links = 0
<006.http://www.s30labs.com> Return Code = 200

Sus parámetros de ejecución son:

 linux_metric_www_status.pl -ip 86.109.126.250 -u http://www.s30labs.com -ok 200
 linux_metric_www_status.pl -ip 86.109.126.250 -u http://www.s30labs.com -error 500
 linux_metric_www_status.pl -h

-ip
      Direccion IP
 -u
      URL sobre la que se hace la peticion
 -ok 
      Codigo HTTP para estado OK
 -error
      Codigo HTTP para estado de Error
 -l
      Lista las metricas que obtiene (es necesario especificar el parametro u)
',
      );

?>
