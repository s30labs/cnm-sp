<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_event_counter.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Provides the number of events received.
The script returns the number of events received from a specific APP or a specific host by syslog or traps during the interval specified in lapse with the pattern specified in pattern.

It provides one metric:

 <001> Event Counter = 6

The parameters are:

 linux_metric_event_counter.pl -app 333333000006 -lapse 120 -pattern "MDW_Alert_Type":"MAT" [-v]
 linux_metric_event_counter.pl -app 333333000006 -lapse 120 -pattern "MDW_Alert_Type|eq|MAT" -json [-v]
 linux_metric_event_counter.pl -app 333333000006 -lapse 120 -pattern "Date":"__CURRENT_DATE__ -current_date "aaaa-mm-dd"
 linux_metric_event_counter.pl -app 333333000006 -lapse 120 -pattern "TRANSCOLA|gt|10&AND&MDW_Alert_Type|eq|MAT" -json [-v]
 linux_metric_event_counter.pl -syslog ip -lapse 120 -pattern "FTP.Login.Failed" [-v]
 linux_metric_event_counter.pl -trap ip|id_dev|name.domain -lapse 120 -pattern "FTP.Login.Failed" [-v]
 linux_metric_event_counter.pl -h  : Help

 -host       : Host al que se asocia la metrica
 -app        : ID de la app.
 -syslog     : IP del equipo que envia por syslog.
 -trap       : IP|id_dev|name.domain del equipo que envia el trap.
 -lapse      : Intervalo seleccionado referenciado desde el instante actual (now-lapse). Se especifica en minutos. Por defecto 60.
 -pattern    : Patron de busqueda. Por defecto se cuentan todos los eventos.
 -json       : Decodifica la linea en JSON. Permite condiciones mas complejas.
               En este caso pattern puede ser una lista de condiciones separadas por &AND& o &OR&
               Cada condicion es del tipo: TRANSCOLA|gt|10 o ERRORMSG|eq|"" -> key|operador|value
               Los operadores soportados son: gt, gte, lt, lte, eq, ne
-current_date: Formato de la variable __CURRENT_DATE__ en pattern. ["aaaa-mm-dd"]
 -v/-verbose : Verbose output (debug)
 -h/-help    : Help
',
      );

?>
