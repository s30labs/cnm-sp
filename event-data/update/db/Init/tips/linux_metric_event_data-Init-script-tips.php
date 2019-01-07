<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_event_data.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Provides a value stored in an event field.
The script returns the value contained in a JSON event field specified received from a specific APP or a specific host by syslog or traps during the interval specified in lapse with the pattern specified in pattern.

It provides one metric:

 <001> Field Value = 6

The parameters are:

 linux_metric_event_data.pl -app 333333000004 -lapse 120 -pattern "CNM_Flag":"01" -field total [-v]
 linux_metric_event_data.pl -h  : Help

 -host       : Host al que se asocia la metrica
 -app        : ID de la app.
 -syslog     : IP del equipo que envia por syslog.
 -trap       : IP|id_dev|name.domain del equipo que envia el trap.
 -lapse      : Intervalo seleccionado referenciado desde el instante actual (now-lapse). Se especifica en minutos. Por defecto 60.
 -pattern    : Patron de busqueda. Por defecto se cuentan todos los eventos.
 -field      : Campo JSON que contiene el dato solicitado
 -oper       : value (none) | sum ...
 -v/-verbose : Verbose output (debug)
 -h/-help    : Help
',
      );

?>
