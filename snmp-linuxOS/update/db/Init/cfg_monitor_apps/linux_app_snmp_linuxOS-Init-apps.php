<?php
      $CFG_MONITOR_APPS[]=array(
         'type' => 'xagent', 'subtype'=>'Win',  'name'=>'INFO DEL SISTEMA OPERATIVO (SNMP)',
         'descr' => '',
         'cmd' => '',
         'params' => '',      'iptab'=>'1', 'ready'=>'1',
         'myrange' => '',   'enterprise'=>'0',
         'cfg' => '0',  'platform' => 'linux',   'script' => 'linux_app_snmp_linuxOS.pl',   'format'=>1,
         'custom' => '0', 'aname'=> 'app_snmp_linuxos', 'res'=>1, 'ipparam'=>'',
         'apptype' => 'SO.LINUX',  'itil_type' => '1'
      );

?>
