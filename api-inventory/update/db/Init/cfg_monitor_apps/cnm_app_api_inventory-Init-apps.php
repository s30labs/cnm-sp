<?php
      $CFG_MONITOR_APPS[]=array(
         'type' => 'xagent', 'subtype'=>'CNM-Admin',  'name'=>'INVENTARIO DE DISPOSITIVOS',
         'descr' => '',
         'cmd' => '',
         'params' => '',      'iptab'=>'0', 'ready'=>'1',
         'myrange' => '',   'enterprise'=>'0',
         'cfg' => '0',  'platform' => '*',   'script' => 'cnm_app_api_inventory.pl',   'format'=>1,
         'custom' => '0', 'aname'=> 'app_cnm_csv_devices', 'res'=>1, 'ipparam'=>'',
         'apptype' => 'CNM',  'itil_type' => '1'
      );

      $CFG_MONITOR_APPS[]=array(
         'type' => 'xagent', 'subtype'=>'CNM-Admin',  'name'=>'INVENTARIO DE METRICAS',
         'descr' => '',
         'cmd' => '',
         'params' => '',      'iptab'=>'0', 'ready'=>'1',
         'myrange' => '',   'enterprise'=>'0',
         'cfg' => '0',  'platform' => '*',   'script' => 'cnm_app_api_inventory.pl',   'format'=>1,
         'custom' => '0', 'aname'=> 'app_cnm_csv_metrics', 'res'=>1, 'ipparam'=>'',
         'apptype' => 'CNM',  'itil_type' => '1'
      );

      $CFG_MONITOR_APPS[]=array(
         'type' => 'xagent', 'subtype'=>'CNM-Admin',  'name'=>'INVENTARIO DE VISTAS',
         'descr' => '',
         'cmd' => '',
         'params' => '',      'iptab'=>'0', 'ready'=>'1',
         'myrange' => '',   'enterprise'=>'0',
         'cfg' => '0',  'platform' => '*',   'script' => 'cnm_app_api_inventory.pl',   'format'=>1,
         'custom' => '0', 'aname'=> 'app_cnm_csv_views', 'res'=>1, 'ipparam'=>'',
         'apptype' => 'CNM',  'itil_type' => '1'
      );

      $CFG_MONITOR_APPS[]=array(
         'type' => 'xagent', 'subtype'=>'CNM-Admin',  'name'=>'INVENTARIO DE METRICAS DEFINIDAS EN VISTAS',
         'descr' => '',
         'cmd' => '',
         'params' => '',      'iptab'=>'0', 'ready'=>'1',
         'myrange' => '',   'enterprise'=>'0',
         'cfg' => '0',  'platform' => '*',   'script' => 'cnm_app_api_inventory.pl',   'format'=>1,
         'custom' => '0', 'aname'=> 'app_cnm_csv_view_metrics', 'res'=>1, 'ipparam'=>'',
         'apptype' => 'CNM',  'itil_type' => '1'
      );

?>
