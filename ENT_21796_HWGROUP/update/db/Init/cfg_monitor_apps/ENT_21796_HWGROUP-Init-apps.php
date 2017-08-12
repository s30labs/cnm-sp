<?php

      $CFG_MONITOR_APPS[]=array(
         'type' => 'snmp', 'subtype'=>'HWGROUP', 'itil_type'=>'1',  'name'=>'VALORES DEL SENSOR',
         'descr' => 'Muestra la tablacon lainformacion reportada por el sensor',
         'cmd' => '/opt/crawler/bin/libexec/snmptable -f 21796-STE-MIB-SENSOR-TABLE.xml -w xml  ',
         'params' => '[-n;IP;]',			'iptab'=>'1',	'ready'=>1,
         'myrange' => 'STE-MIB::sensTable',
         'cfg' => '0',  'platform' => '*',   'script' => 'snmptable',   'format'=>1,   'enterprise'=>'21796',
			'custom' => '0', 'aname'=>'app_hwg_ste_table', 'res'=>1, 'ipparam'=>'[-n;IP;]',  'apptype'=>'NET.HWGROUP', 
      );


?>
