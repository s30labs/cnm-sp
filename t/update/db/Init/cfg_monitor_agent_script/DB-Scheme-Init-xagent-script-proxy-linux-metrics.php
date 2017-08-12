<?php

//---------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------
/*

Para dar de alta un script predefinido en el sistema, hay que tocar:

update/db/Init/cfg_monitor_agent_script/DB-Scheme-Init-xagent-script-proxy-linux-metrics.php
update/db/Init/cfg_script_param/DB-Scheme-Init-script-params-proxy-linux-metrics.php
update/db/Init/tips/DB-Scheme-Init-tips-scripts-metrics.php

	cfg=0 METRICA
	cfg=1 APP

exec_mode => 0 (No aparece en listados-interna), 1 (Aparece pero solo proxy local), 2 (Aparece y se puede seleccionar proxy)
*/
//---------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------

      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'linux_metric_mysql_var.pl',				'exec_mode' => 1, 'timeout'=>30,
            'description' => '',
            'proxy_type' => 'linux', 'cfg' => '0',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'cnm123',
      );
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'linux_metric_mail_loop.pl',				'exec_mode' => 1, 'timeout'=>30,
            'description' => '',
            'proxy_type' => 'linux', 'cfg' => '0',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'cnm123',
      );
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'linux_metric_ssh_files_per_proccess.pl',		'exec_mode' => 1, 'timeout'=>30,
            'description' => '',
            'proxy_type' => 'linux', 'cfg' => '0',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'cnm123',
      );
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'linux_metric_ssh_files_in_dir.pl',				'exec_mode' => 1, 'timeout'=>30,
            'description' => '',
            'proxy_type' => 'linux', 'cfg' => '0',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'cnm123',
      );
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'linux_metric_route_tag.pl',			'exec_mode' => 1, 'timeout'=>30,
            'description' => '',
            'proxy_type' => 'linux', 'cfg' => '0',  'custom' => '0', 'proxy_user'=>'root', 'proxy_pwd'=>'cnm123',
      );

		//---------------------------------------------------------------------------------------------------------
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'win32_metric_wmi_core.vbs',			'exec_mode' => 1, 'timeout'=>30,
            'description' => '',
            'proxy_type' => 'windows', 'cfg' => '0',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'cnm',
      );


		//---------------------------------------------------------------------------------------------------------
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'linux_metric_snmp_count_proc_multiple_devices.pl',		'exec_mode' => 1, 'timeout'=>30,
            'description' => '',
            'proxy_type' => 'linux', 'cfg' => '0',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'cnm',
      );


		//---------------------------------------------------------------------------------------------------------
      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'linux_metric_mon_dns.pl',      'exec_mode' => 1, 'timeout'=>30, 
            'description' => '',
            'proxy_type' => 'linux', 'cfg' => '0',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'cnm',
      );

      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'linux_metric_mon_http_uri_response.pl',      'exec_mode' => 1, 'timeout'=>30,
            'description' => '',
            'proxy_type' => 'linux', 'cfg' => '0',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'cnm',
      );

      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'linux_metric_mon_imap.pl',      'exec_mode' => 1, 'timeout'=>30,
            'description' => '',
            'proxy_type' => 'linux', 'cfg' => '0',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'cnm',
      );

      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'linux_metric_mon_pop3.pl',      'exec_mode' => 1, 'timeout'=>30,
            'description' => '',
            'proxy_type' => 'linux', 'cfg' => '0',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'cnm',
      );

      $CFG_MONITOR_AGENT_SCRIPT[]=array(
            'script' => 'linux_metric_mon_smtp.pl',      'exec_mode' => 1, 'timeout'=>30,
            'description' => '',
            'proxy_type' => 'linux', 'cfg' => '0',  'custom' => '0', 'proxy_user'=>'www-data', 'proxy_pwd'=>'cnm',
      );

?>
