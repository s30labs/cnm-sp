<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004000',   'class' => 'proxy-linux',  'description' => 'CADUCIDAD DE CERTIFICADO SSL HTTPS/443 (sgs)',
            'apptype' => 'IPSERV.SSL',  'itil_type' => '1',    'tag' => '001',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'T (segs)',        'vlabel' => 'T(segs)',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-p;Puerto;443;0]:[-t;Protocolo;https;0]',      'params_descr' => '',
            'script' => 'linux_metric_ssl_certs.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>0,
				'myrange' => 'ssl-check,[-n;IP;;2]:[-p;Puerto;443;0]:[-t;Protocolo;https;0]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004001',   'class' => 'proxy-linux',  'description' => 'CADUCIDAD DE CERTIFICADO SSL HTTPS/443 (d)',
            'apptype' => 'IPSERV.SSL',  'itil_type' => '1',    'tag' => '002',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'T (days)',        'vlabel' => 'T(days)',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-p;Puerto;443;0]:[-t;Protocolo;https;0]',      'params_descr' => '',
            'script' => 'linux_metric_ssl_certs.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'ssl-check,[-n;IP;;2]:[-p;Puerto;443;0]:[-t;Protocolo;https;0]',
      );
?>
