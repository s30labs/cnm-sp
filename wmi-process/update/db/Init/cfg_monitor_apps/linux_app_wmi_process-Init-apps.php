<?php
      $CFG_MONITOR_APPS[]=array(
         'type' => 'xagent', 'subtype'=>'Win',  'name'=>'OBTENER LOS PROCESOS WINDOWS',
         'descr' => '',
         'cmd' => '',
         'params' => '',      'iptab'=>'1', 'ready'=>'1',
         'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',   'enterprise'=>'0',
         'cfg' => '0',  'platform' => 'win',   'script' => 'linux_app_wmi_process.pl',   'format'=>1,
         'custom' => '0', 'aname'=> 'app_get_win32_process', 'res'=>1, 'ipparam'=>'',
         'apptype' => 'SO.WINDOWS',  'itil_type' => '1'
      );

?>
