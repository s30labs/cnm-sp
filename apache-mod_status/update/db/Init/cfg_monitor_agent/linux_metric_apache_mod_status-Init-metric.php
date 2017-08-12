<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_667d22',   'class' => 'proxy-linux',  'description' => 'APACHE - PETICIONES',
            'apptype' => 'WWW.APACHE',  'itil_type' => '1',    'tag' => '002',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'Num. Peticiones',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]',      'params_descr' => '',
            'script' => 'linux_metric_apache_mod_status.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'apache_mod_status-check,[-n;IP;;2]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_c0d09a',   'class' => 'proxy-linux',  'description' => 'APACHE - WORKERS',
            'apptype' => 'WWW.APACHE',  'itil_type' => '1',    'tag' => '003|004|006|007|009',   'esp'=>'o1|o2|o3|o4|o5',  'iptab' => '1',
            'items' => 'Idle|Waiting|Request|Reply|DNSLookup',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]',      'params_descr' => '',
            'script' => 'linux_metric_apache_mod_status.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'apache_mod_status-check,[-n;IP;;2]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_4ebd09',   'class' => 'proxy-linux',  'description' => 'APACHE - ACCESOS TOTALES',
            'apptype' => 'WWW.APACHE',  'itil_type' => '1',    'tag' => '015',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'Accesos',        'vlabel' => 'Num',      'mode' => 'COUNTER',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]',      'params_descr' => '',
            'script' => 'linux_metric_apache_mod_status.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'apache_mod_status-check,[-n;IP;;2]',
      );
?>
