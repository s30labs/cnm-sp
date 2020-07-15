<?php
      $TIPS[]=array(
         'id_ref' => 'cnm_device_maintenance.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Para definir periodos complejos de mantenimiento, se pueden definir ficheros de calendario en formato JSON para cada dispositvo. Este script comprueba para cada uno de ellos si el dispositivo esta en el estado correcto.

 cnm-device-maintenance.pl [-log-level info|debug] [-log-mode 1|2|3] [-dir-base /cfg] [-custom-field CNM-MAINTENANCE] [-v]
 cnm-device-maintenance.pl -dir-base /cfg/1234 -custom-field my_custom_field
 cnm-device-maintenance.pl -help

 -help : Help
 -v    : Verbose mode
 -log-level : info|debug
 -log-mode : 1 => syslog | 2 => stdout | 3 => both
 -dir-base : /cfg (default)
 -custom-field : CNM-MAINTENANCE (default)
',
      );

?>
