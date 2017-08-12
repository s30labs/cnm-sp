<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004400',   'class' => 'proxy-linux',  'description' => 'PROCESOS ZOMBIE',
            'apptype' => 'SO.LINUX',  'itil_type' => '1',    'tag' => '001',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'Num. Processes',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '1',
            'params' => '[-n;IP;;2]',      'params_descr' => '',
            'script' => 'linux_metric_ssh_linuxOS.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>0,
				'myrange' => 'ssh-check,[-n;IP;;2]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004401',   'class' => 'proxy-linux',  'description' => 'UPTIME DEL SISTEMA',
            'apptype' => 'SO.LINUX',  'itil_type' => '1',    'tag' => '003',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'T (sgs)',        'vlabel' => 'T(sgs)',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '1',
            'params' => '[-n;IP;;2]',      'params_descr' => '',
            'script' => 'linux_metric_ssh_linuxOS.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'ssh-check,[-n;IP;;2]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004402',   'class' => 'proxy-linux',  'description' => 'INODOS USADOS EN DISCO',
            'apptype' => 'SO.LINUX',  'itil_type' => '1',    'tag' => '008',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'Inodos usados (%)',        'vlabel' => 'Num(%)',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '1',
            'params' => '[-n;IP;;2]',      'params_descr' => '',
            'script' => 'linux_metric_ssh_linuxOS.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'ssh-check,[-n;IP;;2]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004403',   'class' => 'proxy-linux',  'description' => 'USO DE DISCO',
            'apptype' => 'SO.LINUX',  'itil_type' => '1',    'tag' => '008',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'Espacio usado (%)',        'vlabel' => 'Num(%)',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '1',
            'params' => '[-n;IP;;2]',      'params_descr' => '',
            'script' => 'linux_metric_ssh_linuxOS.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'ssh-check,[-n;IP;;2]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004404',   'class' => 'proxy-linux',  'description' => 'TRAFICO EN INTERFAZ',
            'apptype' => 'SO.LINUX',  'itil_type' => '1',    'tag' => '039|040',   'esp'=>'o1|o2',  'iptab' => '1',
            'items' => 'Rx bits | Tx bits',        'vlabel' => 'bps',      'mode' => 'COUNTER',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '1',
            'params' => '[-n;IP;;2]',      'params_descr' => '',
            'script' => 'linux_metric_ssh_linuxOS.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'ssh-check,[-n;IP;;2]',
      );
?>
