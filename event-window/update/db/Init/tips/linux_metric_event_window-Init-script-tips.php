<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_event_window.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Provides the values for monitoring if a specific event happens in a temporal window specified by parameters.

It provides the following metric data: 
<001> Monitoring Window = 0
 <002> Error Window = 0
 <003> Number of Items = U
 <004> Received Status Time Lapse (min) = 0
 <005> Wait Status Time Lapse (min) = 0

The parameters are:

 -host       : Host for metric association.
 -app        : APP Id.
 -wt         : Window Time for positioning the center of the window. (several values specified by comma)
               Valid formats are: "8" "8,15" "8:30,15:30"
 -ws         : Window size (in minutes). Default is 60.
 -lapse      : APP ID table querying lapse from current time. (minutes)
 -pattern    : APP ID table querying pattern. E
 -v/-verbose : Verbose output (debug)
 -h/-help    : Help
',
      );

?>
