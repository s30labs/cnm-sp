<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004010',   'class' => 'proxy-linux',  'description' => 'TIEMPO DE RESPUESTA DEL PUERTO 80/TCP',
            'apptype' => 'IPSERV.WWW',  'itil_type' => '1',    'tag' => '001',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'T (segs)',        'vlabel' => 'T(segs)',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-p;Puerto;80;0]:[-t;Timeout;2;0]',      'params_descr' => '',
            'script' => 'linux_metric_tcp_check.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>0,
				'myrange' => 'tcp-check,[-n;IP;;2]:[-p;Puerto;80;0]:[-t;Timeout;2;0]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004011',   'class' => 'proxy-linux',  'description' => 'ESTADO DEL PUERTO 80/TCP',
            'apptype' => 'IPSERV.WWW',  'itil_type' => '1',    'tag' => '002',   'esp'=>'MAP(1)(1,0,0)|MAP(2)(0,1,0)|MAP(3)(0,0,1)',  'iptab' => '1',
            'items' => 'Ok(1)|Unknown(2)|Nok(3)',        'vlabel' => 'T(hours)',      'mode' => 'GAUGE',
            'mtype' => 'STD_SOLID',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-p;Puerto;80;0]:[-t;Timeout;2;0]',      'params_descr' => '',
            'script' => 'linux_metric_tcp_check.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>0,
				'myrange' => 'tcp-check,[-n;IP;;2]:[-p;Puerto;80;0]:[-t;Timeout;2;0]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004012',   'class' => 'proxy-linux',  'description' => 'TIEMPO DE RESPUESTA DEL PUERTO 443/TCP',
            'apptype' => 'IPSERV.WWW',  'itil_type' => '1',    'tag' => '001',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'T (segs)',        'vlabel' => 'T(segs)',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-p;Puerto;443;0]:[-t;Timeout;2;0]',      'params_descr' => '',
            'script' => 'linux_metric_tcp_check.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>0,
				'myrange' => 'tcp-check,[-n;IP;;2]:[-p;Puerto;443;0]:[-t;Timeout;2;0]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004013',   'class' => 'proxy-linux',  'description' => 'ESTADO DEL PUERTO 443/TCP',
            'apptype' => 'IPSERV.WWW',  'itil_type' => '1',    'tag' => '002',   'esp'=>'MAP(1)(1,0,0)|MAP(2)(0,1,0)|MAP(3)(0,0,1)',  'iptab' => '1',
            'items' => 'Ok(1)|Unknown(2)|Nok(3)',        'vlabel' => 'T(hours)',      'mode' => 'GAUGE',
            'mtype' => 'STD_SOLID',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-p;Puerto;443;0]:[-t;Timeout;2;0]',      'params_descr' => '',
            'script' => 'linux_metric_tcp_check.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>0,
				'myrange' => 'tcp-check,[-n;IP;;2]:[-p;Puerto;443;0]:[-t;Timeout;2;0]',
      );
?>
