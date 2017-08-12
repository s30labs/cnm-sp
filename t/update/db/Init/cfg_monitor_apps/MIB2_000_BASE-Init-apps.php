<?php

      $CFG_MONITOR_APPS[]=array(
         'type' => 'snmp', 'subtype'=>'MIB2', 'itil_type'=>'1',  'name'=>'TABLA DE ARP',
         'descr' => 'Muestra la tabla de ARP del dispositivo (IP/direccion MAC)',
         'cmd' => '/opt/crawler/bin/libexec/snmptable -f 00000-MIB2-IP-ARP.xml -w xml  ',
         'params' => '[-n;IP;]',			'iptab'=>'1',	'ready'=>1,
         'myrange' => 'IP-MIB::ipNetToMediaTable',
         'cfg' => '0',  'platform' => '*',   'script' => 'snmptable',   'format'=>1,   'enterprise'=>'00000',
			'custom' => '0', 'aname'=>'app_mib2_arptable', 'res'=>1, 'ipparam'=>'[-n;IP;]',  'apptype'=>'NET.MIB2', 
      );



      $CFG_MONITOR_APPS[]=array(
         'type' => 'snmp', 'subtype'=>'MIB2', 'itil_type'=>'1',  'name'=>'TABLA DE RUTAS',
         'descr' => 'Muestra la tabla derutas del dispositivo. Conviene tener precaucion con aquellos dispositivos con gran numero de rutas porque puede aumentar la carga del equipo',
         'cmd' => '/opt/crawler/bin/libexec/snmptable -f 00000-MIB2-RFC1213-ROUTES.xml  -w xml  ',
         'params' => '[-n;IP;]',			'iptab'=>'1',	'ready'=>1,
         'myrange' => 'RFC1213-MIB::ipRouteTable',
         'cfg' => '0',  'platform' => '*',   'script' => 'snmptable',   'format'=>1,   'enterprise'=>'00000',
			'custom' => '0', 'aname'=>'app_mib2_routetable', 'res'=>1, 'ipparam'=>'[-n;IP;]',  'apptype'=>'NET.MIB2', 
      );



      $CFG_MONITOR_APPS[]=array(
         'type' => 'snmp', 'subtype'=>'MIB2', 'itil_type'=>'1',  'name'=>'SESIONES TCP',
         'descr' => 'Muestra las sesiones TCP del dispositivo',
         'cmd' => '/opt/crawler/bin/libexec/snmptable -f 00000-MIB2-TCP-CONNECTIONS.xml  -w xml  ',
         'params' => '[-n;IP;]',			'iptab'=>'1',	'ready'=>1,
         'myrange' => 'TCP-MIB::tcpConnTable',
         'cfg' => '0',  'platform' => '*',   'script' => 'snmptable',   'format'=>1,   'enterprise'=>'00000',
			'custom' => '0', 'aname'=>'app_mib2_tcpsessions', 'res'=>1, 'ipparam'=>'[-n;IP;]',  'apptype'=>'NET.MIB2', 
      );



      $CFG_MONITOR_APPS[]=array(
         'type' => 'snmp', 'subtype'=>'MIB2', 'itil_type'=>'1',  'name'=>'PUERTOS UDP',
         'descr' => 'Muestra los puertos UDP utilizados por el dispositivo',
         'cmd' => '/opt/crawler/bin/libexec/snmptable -f 00000-MIB2-UDP-PORTS.xml  -w xml  ',
         'params' => '[-n;IP;]',			'iptab'=>'1',	'ready'=>1,
         'myrange' => 'UDP-MIB::udpTable',
         'cfg' => '0',  'platform' => '*',   'script' => 'snmptable',   'format'=>1,   'enterprise'=>'00000',
			'custom' => '0', 'aname'=>'app_mib2_udpports', 'res'=>1, 'ipparam'=>'[-n;IP;]',  'apptype'=>'NET.MIB2', 
      );


?>
