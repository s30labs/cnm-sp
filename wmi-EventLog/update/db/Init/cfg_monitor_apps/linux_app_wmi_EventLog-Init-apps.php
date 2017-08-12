<?php
      $CFG_MONITOR_APPS[]=array(
         'type' => 'xagent', 'subtype'=>'Win',  'name'=>'OBTENER ENTRADAS DEL VISOR DE EVENTOS',
         'descr' => '',
         'cmd' => '',
         'params' => '',      'iptab'=>'1', 'ready'=>'1',
         'myrange' => '',   'enterprise'=>'0',
         'cfg' => '0',  'platform' => 'win',   'script' => 'linux_app_wmi_EventLog.pl',   'format'=>1,
         'custom' => '0', 'aname'=> 'app_get_event_log', 'res'=>1, 'ipparam'=>'',
         'apptype' => 'SO.WINDOWS',  'itil_type' => '1'
      );

?>
