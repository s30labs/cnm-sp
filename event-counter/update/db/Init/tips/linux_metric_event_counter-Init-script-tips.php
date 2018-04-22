<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_event_counter.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Provides the number of events received.
The script returns the number of events received from a specific APP or a specific host by syslog or traps during the interval specified in lapse with the pattern specified in pattern.

It provides one metric:

 <001> Event Counter = 6

The parameters are:

 linux_metric_event_counter.pl -app 333333000006 -lapse 120 -pattern "key":"val" [-v]
 linux_metric_event_counter.pl -syslog ip -lapse 120 -pattern "FTP.Login.Failed" [-v]
 linux_metric_event_counter.pl -trap ip|id_dev|name.domain -lapse 120 -pattern "FTP.Login.Failed" [-v]
 linux_metric_event_counter.pl -h  : Help

 -app        : ID de la app.
 -syslog     : IP del equipo que envia por syslog.
 -trap       : IP|id_dev|name.domain del equipo que envia el trap.
 -lapse      : Intervalo seleccionado referenciado desde el instante actual (now-lapse). Se especifica en minutos. Por defecto 60.
 -pattern    : Patron de busqueda. Por defecto se cuentan todos los eventos.
 -v/-verbose : Verbose output (debug)
 -h/-help    : Help
',
      );

?>
