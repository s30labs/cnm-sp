<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_tcp_connections.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este script permite obtener las sesiones TCP reportadas en relac�on a los puertos servidores especificados.

Las sesiones se  agrupan por "Established, Listen, Time Wait, Others".
<001.22> Established in port 22 <002.22> Listen in port 22 <003.22> Time Wait in port 22 <004.22> Other in port 22

Sus parámetros de ejecución son:

 linux_metric_tcp_connections.pl -ip 86.109.126.250 -port 22
 linux_metric_tcp_connections.pl -h

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
 -v, -verbose
      Muestra informacion extra(debug)
 -h, -help
      Ayuda
 -l
      Lista las metricas que obtiene (es necesario especificar u,url,n o id)
',
      );

?>
