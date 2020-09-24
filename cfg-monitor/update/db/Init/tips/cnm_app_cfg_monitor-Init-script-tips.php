<?php
      $TIPS[]=array(
         'id_ref' => 'cnm_app_cfg_monitor.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Permite activar o desactivar los monitores especificados en la seccion __DATA__ del script. El contenido de esta seccion se debe adaptar a las necesidades concretas que apliquen en cada caso. Sus parametros de ejecucuon son:

 cnm_app_cfg_monitor.pl [-ip x.x.x.x] -set
 cnm_app_cfg_monitor.pl [-ip x.x.x.x] -clr

 -ip         : Opcional. Permite acsociar el script a un dispositivo.
 -set        : Activa monitores
 -clr        : Desactiva monitores
 -v/-verbose : Verbose output (debug)
 -h/-help    : Help',
      );

?>
