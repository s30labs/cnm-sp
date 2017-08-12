<?php

// Posibles valores de myrange
// * -> Patra todo el mundo
// EN SNMP 		>>	HOST-RESOURCES-MIB::hrStorageTable
// EN LATENCY 	>> comando a chequear
// EN XAGENT 	>>	win32::wmi::cimv2::Win32_Process
//						linux::lsof
// ip:localhost Para la ip especificada
// oid:.1.2.1.2... Para el oid especificado


// itil_type: operacion 1, configuracion 2, capacidad 3, disponibilidad 4, seguridad 5
// cfg: 0-> No instanciada, 1-> Instanciada

// format hace referencia al formato de salida generado por la aplicacion
// 0=> La aplicacion no genera formato
// 1=> La aplicacion compone el xml

// enterprise es necesario para optimizar el chequeo de las snmp. En el resto de casos por
// ahora no tiene uso

// res=1 => Tiene resultados (hay solapa)
// res=0 => No tiene resultados (no hay solapa)

		// LATENCY  --------------------------------------------------------------
      $CFG_MONITOR_APPS[]=array(
			'type' => 'latency',	'subtype'=>'ICMP',	'itil_type'=>'4', 'name'=>'PING-10',
			'descr' => 'Ejecuta un ping de 10 paquetes de 64 bytes',
			'cmd' => '/bin/ping -c 10 ',  'params' => '[;IP;]',		'iptab'=>'1',	'ready'=>1,
			'myrange' => '/bin/ping -c 10 ',
			'cfg' => '0',	'platform' => '*',	'script' => 'cnm-ping',	'format'=>0,	'enterprise'=>'0',
			'custom' => '0', 'aname'=> 'app_icmp_ping10', 'res'=>1, 'ipparam'=>'[;IP;]',
			'apptype' => 'NET.BASE',	'itil_type' => '1',
      );
      $CFG_MONITOR_APPS[]=array(
         'type' => 'latency', 'subtype'=>'ICMP',	'itil_type'=>'4',	'name'=>'PING-10 (largo)',
         'descr' => 'Ejecuta un ping de 10 paquetes de 1024 bytes',
         'cmd' => '/bin/ping -c 10 -s 1024 ',	'params' => '[;IP;]',	'iptab'=>'1',	'ready'=>1,
         'myrange' => '/bin/ping -c 10 -s 1024 ',		
			'cfg' => '0',	'platform' => '*',	'script' => 'cnm-ping',   'format'=>0,   'enterprise'=>'0',
         'custom' => '0', 'aname'=> 'app_icmp_ping1024', 'res'=>1, 'ipparam'=>'[;IP;]',
			'apptype' => 'NET.BASE',	'itil_type' => '1',
      );
      $CFG_MONITOR_APPS[]=array(
         'type' => 'latency', 'subtype'=>'TCP', 'itil_type'=>'4',  'name'=>'TRACEROUTE',
         'descr' => 'Muestra el numero de saltos hasta un destino',
         'cmd' => '/usr/sbin/traceroute ', 	'params' => '[;IP;]',	'iptab'=>'1',	'ready'=>1,
         'myrange' => '/usr/sbin/traceroute ',
			'cfg' => '0',	'platform' => '*',	'script' => 'cnm-traceroute',   'format'=>0,   'enterprise'=>'0',
         'custom' => '0', 'aname'=> 'app_tcp_traceroute', 'res'=>1, 'ipparam'=>'[;IP;]',
			'apptype' => 'NET.BASE',	'itil_type' => '1',
      );
      $CFG_MONITOR_APPS[]=array(
         'type' => 'latency', 'subtype'=>'TCP', 'itil_type'=>'4',  'name'=>'MONITOR TCP',
         'descr' => 'Establece una conexion TCP',		'iptab'=>'1',	'ready'=>0,
         'cmd' => '/opt/crawler/bin/libexec/mon_tcp ',	'params' => '[-n;IP;]:[-p;Puerto;]',
         'myrange' => '/opt/crawler/bin/libexec/mon_tcp ',
			'cfg' => '0',	'platform' => '*',	'script' => 'mon_tcp',   'format'=>0,   'enterprise'=>'0',
         'custom' => '0', 'aname'=> 'app_tcp_monitor', 'res'=>1, 'ipparam'=>'[-n;IP;]',
			'apptype' => 'NET.BASE',	'itil_type' => '1',
      );

// Esta es para probar que se manejan bien las aplicaciones instanciadas
      $CFG_MONITOR_APPS[]=array(
         'type' => 'latency', 'subtype'=>'SMTP', 'itil_type'=>'4',  'name'=>'MONITOR SMTP',
         'descr' => 'Establece una conexion TCP por el puerto 25',		'iptab'=>'1',	'ready'=>1,
         'cmd' => '/opt/crawler/bin/libexec/mon_smtp_ext ', 'params' => '[-n;IP;]:[-p;Puerto;25]',
         'myrange' => '/opt/crawler/bin/libexec/mon_smtp_ext ',
         'cfg' => '1',  'platform' => '*',   'script' => 'mon_smtp_ext',   'format'=>0,   'enterprise'=>'0',
         'custom' => '0', 'aname'=> 'app_smtp_monitor', 'res'=>1, 'ipparam'=>'[-n;IP;]',
			'apptype' => 'NET.BASE',	'itil_type' => '1',
      );


      $CFG_MONITOR_APPS[]=array(
         'type' => 'latency', 'subtype'=>'TCP', 'itil_type'=>'4',  'name'=>'ESCANEO DE PUERTOS',
         'descr' => 'Hace un escaneo de los primeros 10000 puertos TCP',		'iptab'=>'1',	'ready'=>1,
         'cmd' => '/usr/bin/sudo /usr/bin/nmap -sS -T4 -p 1-10000 ', 'params' => '[;IP;]',
         'myrange' => '/usr/bin/nmap ',
         'cfg' => '1',  'platform' => '*',   'script' => 'cnm-nmap',   'format'=>0,   'enterprise'=>'0',
         'custom' => '0', 'aname'=> 'app_tcp_scanports', 'res'=>1, 'ipparam'=>'[;IP;]',
			'apptype' => 'NET.BASE',	'itil_type' => '1',
      );

      $CFG_MONITOR_APPS[]=array(
         'type' => 'latency', 'subtype'=>'TCP', 'itil_type'=>'4',  'name'=>'ESCANEO DE SISTEMA OPERATIVO',
         'descr' => 'Hace un escaneo de puertos con el objetivo de detectar el sistema operativo',		'iptab'=>'1',	'ready'=>1,
         'cmd' => '/usr/bin/sudo /usr/bin/nmap  -A -T4 -p 21,22,111,135,139,445,35879 ', 'params' => '[;IP;]',
         'myrange' => '/usr/bin/nmap ',
         'cfg' => '1',  'platform' => '*',   'script' => 'cnm-nmap',   'format'=>0,   'enterprise'=>'0',
         'custom' => '0', 'aname'=> 'app_tcp_scanso', 'res'=>1, 'ipparam'=>'[;IP;]',
			'apptype' => 'NET.BASE',	'itil_type' => '1',
      );

      $CFG_MONITOR_APPS[]=array(
         'type' => 'latency', 'subtype'=>'TCP', 'itil_type'=>'4',  'name'=>'INFORMACION DE CERTIFICADOS SSL',
         'descr' => '',    'iptab'=>'1',  'ready'=>1,
         'cmd' => '', 'params' => '[;IP;]',
         'myrange' => '/usr/bin/openssl ',
         'cfg' => '1',  'platform' => '*',   'script' => 'cnm-sslcerts',   'format'=>0,   'enterprise'=>'0',
         'custom' => '0', 'aname'=> 'app_tcp_sslcerts', 'res'=>1, 'ipparam'=>'[;IP;]',
         'apptype' => 'NET.BASE',   'itil_type' => '1',
      );

?>
