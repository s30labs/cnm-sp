<?php
      $CFG_MONITOR_APPS[]=array(
         'type' => 'xagent', 'subtype'=>'CNM-Admin',  'name'=>'DAR DE BAJA DISPOSITIVO',
         'descr' => '',
         'cmd' => '',
         'params' => '',      'iptab'=>'1', 'ready'=>'1',
         'myrange' => '',   'enterprise'=>'0',
         'cfg' => '0',  'platform' => '*',   'script' => 'cnm_app_api_device.pl',   'format'=>1,
         'custom' => '0', 'aname'=> 'app_cnm_dev_baja', 'res'=>1, 'ipparam'=>'',
         'apptype' => 'CNM',  'itil_type' => '1'
      );

      $CFG_MONITOR_APPS[]=array(
         'type' => 'xagent', 'subtype'=>'CNM-Admin',  'name'=>'ACTIVAR DISPOSITIVO',
         'descr' => '',
         'cmd' => '',
         'params' => '',      'iptab'=>'1', 'ready'=>'1',
         'myrange' => '',   'enterprise'=>'0',
         'cfg' => '0',  'platform' => '*',   'script' => 'cnm_app_api_device.pl',   'format'=>1,
         'custom' => '0', 'aname'=> 'app_cnm_dev_alta', 'res'=>1, 'ipparam'=>'',
         'apptype' => 'CNM',  'itil_type' => '1'
      );

      $CFG_MONITOR_APPS[]=array(
         'type' => 'xagent', 'subtype'=>'CNM-Admin',  'name'=>'PONER EN MANTENIMIENTO DISPOSITIVO',
         'descr' => '',
         'cmd' => '',
         'params' => '',      'iptab'=>'1', 'ready'=>'1',
         'myrange' => '',   'enterprise'=>'0',
         'cfg' => '0',  'platform' => '*',   'script' => 'cnm_app_api_device.pl',   'format'=>1,
         'custom' => '0', 'aname'=> 'app_cnm_dev_mant', 'res'=>1, 'ipparam'=>'',
         'apptype' => 'CNM',  'itil_type' => '1'
      );

?>
