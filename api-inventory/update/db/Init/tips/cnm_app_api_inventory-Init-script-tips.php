<?php
      $TIPS[]=array(
         'id_ref' => 'cnm_app_api_inventory.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este escript permite obtener datos del CNM mediante el API. Sus parámetros de ejecución son:<b
cnm@cnm:/opt/cnm/xagent/base# ./cnm_app_api_inventory.pl -h
cnm_app_api_inventory.pl 1.0

cnm_app_api_inventory.pl [-d] [-cid default] [-host 1.1.1.1] -what [devices|views|metrics|metrics_in_views]
cnm_app_api_inventory.pl -h  : Ayuda

host:  Direccion IP del CNM al que se interroga, por defecto es localhost.
what:  Tipo de inventario: devices, views, metrics, metrics_in_views
extra: Parametros extra (opcional)
',
      );

?>
