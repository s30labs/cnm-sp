<?php
//---------------------------------------------------------------------------------------------------------
/*
	cfg=0 METRICA  cfg=1 APP
	exec_mode=0 No visible para las apps exec_mode=1 Visible (solo usa proxy local)  exec_mode=2 Visible (usa proxy) 
*/
//---------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------
// CNM
//---------------------------------------------------------------------------------------------------------

      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'audit',						'exec_mode' => 1, 'timeout'=>3600,
            'description' => 'AUDITORIA DE RED',
            'proxy_type' => 'linux', 'cfg' => '1',  'custom' => '0', 'proxy_user'=>'root', 'proxy_pwd'=>'',
      );
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'generate_report.php',	'exec_mode' => 0, 'timeout'=>3600,
            'description' => 'GENERADOR DE INFORMES',
            'proxy_type' => 'linux', 'cfg' => '1',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'',
      );
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'cnm_backup.php',			'exec_mode' => 0, 'timeout'=>3600,
            'description' => 'BACKUP DE DATOS DE CNM',
            'proxy_type' => 'linux', 'cfg' => '1',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'',
      );
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'linux_app_restore_passive_from_active.pl',       'exec_mode' => 1, 'timeout'=>3600,
            'description' => 'RESTAURACION DE DATOS DEL EQUIPO PASIVO',
            'proxy_type' => 'linux', 'cfg' => '1',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'',
      );


//---------------------------------------------------------------------------------------------------------
// SNMP
//---------------------------------------------------------------------------------------------------------
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'mib2_if',					'exec_mode' => 0, 'timeout'=>3600,
            'description' => 'LISTA DE INTERFACES',
            'proxy_type' => 'linux', 'cfg' => '1',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'',
      );
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'mibhost_disk',			'exec_mode' => 0, 'timeout'=>3600,
            'description' => 'USO DE DISCO',
            'proxy_type' => 'linux', 'cfg' => '1',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'',
      );
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'get_cdp',					'exec_mode' => 0, 'timeout'=>3600,
            'description' => 'VECINOS POR CDP',
            'proxy_type' => 'linux', 'cfg' => '1',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'',
      );
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'cisco_ccm_device_pools',		'exec_mode' => 0, 'timeout'=>3600,
            'description' => 'CISCO CALL MANAGER - DEVICE POOLS',
            'proxy_type' => 'linux', 'cfg' => '1',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'',
      );
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'snmptable',				'exec_mode' => 0, 'timeout'=>3600,
            'description' => 'OBTIENE TABLA SNMP GENERICA',
            'proxy_type' => 'linux', 'cfg' => '1',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'',
      );

//---------------------------------------------------------------------------------------------------------
// LATENCY
//---------------------------------------------------------------------------------------------------------
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'cnm-ping',				'exec_mode' => 1, 'timeout'=>3600,
            'description' => 'PING ICMP',
            'proxy_type' => 'linux', 'cfg' => '1',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'',
      );
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'cnm-traceroute',		'exec_mode' => 1, 'timeout'=>3600,
            'description' => 'TRACEROUTE',
            'proxy_type' => 'linux', 'cfg' => '1',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'',
      );
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'cnm-nmap',				'exec_mode' => 1, 'timeout'=>3600,
            'description' => 'NMAP',
            'proxy_type' => 'linux', 'cfg' => '1',  'custom' => '0', 'proxy_user'=>'root', 'proxy_pwd'=>'',
      );
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'mon_tcp',				'exec_mode' => 0, 'timeout'=>3600,
            'description' => 'MONITOR DE PUERTO TCP',
            'proxy_type' => 'linux', 'cfg' => '1',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'',
      );
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'cnm-sslcerts',		'exec_mode' => 1, 'timeout'=>3600,
            'description' => 'OBTIENE LA INFORMACION DEL CERTIFICADO SSL',
            'proxy_type' => 'linux', 'cfg' => '1',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'',
      );
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'mon_smtp_ext',		'exec_mode' => 1, 'timeout'=>3600,
            'description' => 'MONITOR SMTP',
            'proxy_type' => 'linux', 'cfg' => '1',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'',
      );


//---------------------------------------------------------------------------------------------------------
// PROXY
//---------------------------------------------------------------------------------------------------------

      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'linux_app_get_conf_telnet_comtrend_router.pl',		'exec_mode' => 1, 'timeout'=>3600,
            'description' => 'OBTIENE LA CONFIGURACION DE ROUTER COMTREND POR TELNET',
            'proxy_type' => 'linux', 'cfg' => '1',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'',
      );

      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'linux_app_get_conf_telnet_cisco_router.pl',			'exec_mode' => 1, 'timeout'=>3600,
            'description' => 'OBTIENE LA CONFIGURACION DE EQUIPO CON CISCO IOS POR TELNET',
            'proxy_type' => 'linux', 'cfg' => '1',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'',
      );

      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'linux_app_check_remote_cfgs.pl',						'exec_mode' => 1, 'timeout'=>3600,
            'description' => 'OBTIENE LOS CAMBIOS ENTRE LAS CONFIGURACIONES ALMACENADAS',
            'proxy_type' => 'linux', 'cfg' => '1',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'',
      );


?>
