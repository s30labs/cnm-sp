<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_event_status.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Maps the last data line received from the specified app that matches a pattern_group with the patterns specified in the mapper section. Each of these patterns provides a numeric value for the metric and all of these rules are defined in the __DATA__ section of the script. In order to use another mapping, the best option is duplicate the script and modify the __DATA__ section accordingly.

It provides the following metric data:

 <001> ItemA (1) | ItemB (0) = 0
 <002> Last ts (seg) = 1559236336
 <003> Last ts lapse (min) = 10

The parameters are:

 linux_metric_event_status.pl -host 1.1.1.1 -app 33333300000x [-v]
 linux_metric_event_status.pl -h  : Help

 -host       : Host al que se asocia la metrica
 -app        : ID de la app.
 -v/-verbose : Verbose output (debug)
 -h/-help    : Help
',
      );

?>
