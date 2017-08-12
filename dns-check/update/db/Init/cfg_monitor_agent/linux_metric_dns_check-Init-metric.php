<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004018',   'class' => 'proxy-linux',  'description' => 'TIEMPO DE RESPUESTA DEL DNS (Google)',
            'apptype' => 'IPSERV.WWW',  'itil_type' => '1',    'tag' => '001|002',   'esp'=>'o1|o2',  'iptab' => '1',
            'items' => 'DNS1 Latency (seg)|DNS2 Latency (seg)',        'vlabel' => 'T(segs)',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-s;DNS Servers;8.8.8.8,8.8.4.4;0]:[-t;Timeout;2;0]',      'params_descr' => '',
            'script' => 'linux_metric_dns_check.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'dns-check,[-n;IP;;2]:[-s;DNS Servers;8.8.8.8,8.8.4.4;0]:[-t;Timeout;2;0]',
      );
?>
