<?php

      $CFG_MONITOR_APPS[]=array(
         'type' => 'snmp', 'subtype'=>'MIB2-HOST', 'itil_type'=>'1',  'name'=>'USO DE DISCO',
         'descr' => 'Uso del disco y particiones definidas',
         'cmd' => '/opt/crawler/bin/libexec/snmptable -f 00000-MIBHOST-DISK.xml -w xml  ',
         'params' => '[-n;IP;]',			'iptab'=>'1',	'ready'=>1,
         'myrange' => 'HOST-RESOURCES-MIB::hrStorageTable',
         'cfg' => '0',  'platform' => '*',   'script' => 'snmptable',   'format'=>1,   'enterprise'=>'00000',
			'custom' => '0', 'aname'=>'app_mib2_diskuse', 'res'=>1, 'ipparam'=>'[-n;IP;]',  'apptype'=>'NET.HOST-MIB', 
      );



      $CFG_MONITOR_APPS[]=array(
         'type' => 'snmp', 'subtype'=>'MIB2-HOST', 'itil_type'=>'1',  'name'=>'PROCESOS EN CURSO',
         'descr' => 'Muestra la lista de procesos que se estan ejecutando en la maquina, junto con el uso de CPU y memoria',
         'cmd' => '/opt/crawler/bin/libexec/snmptable -f 00000-MIBHOST-CPU.xml -w xml  ',
         'params' => '[-n;IP;]',			'iptab'=>'1',	'ready'=>1,
         'myrange' => 'HOST-RESOURCES-MIB::hrSWRunTable',
         'cfg' => '0',  'platform' => '*',   'script' => 'snmptable',   'format'=>1,   'enterprise'=>'00000',
			'custom' => '0', 'aname'=>'app_mib2_processesrunning', 'res'=>1, 'ipparam'=>'[-n;IP;]',  'apptype'=>'NET.HOST-MIB', 
      );



      $CFG_MONITOR_APPS[]=array(
         'type' => 'snmp', 'subtype'=>'MIB2-HOST', 'itil_type'=>'1',  'name'=>'SOFTWARE INSTALADO',
         'descr' => 'Lista de programas instalados',
         'cmd' => '/opt/crawler/bin/libexec/snmptable -f 00000-MIBHOST-SW.xml -w xml  ',
         'params' => '[-n;IP;]',			'iptab'=>'1',	'ready'=>1,
         'myrange' => 'HOST-RESOURCES-MIB::hrSWInstalledTable',
         'cfg' => '0',  'platform' => '*',   'script' => 'snmptable',   'format'=>1,   'enterprise'=>'00000',
			'custom' => '0', 'aname'=>'app_mib2_softwareinstalled', 'res'=>1, 'ipparam'=>'[-n;IP;]',  'apptype'=>'NET.HOST-MIB', 
      );


?>
