<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004610',   'class' => 'proxy-linux',  'description' => 'WEB PAGE SCORE',
            'apptype' => 'IPSERV.WWW',  'itil_type' => '1',    'tag' => '001',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'Overall Score',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '1',
            'params' => '[-n;IP;;2]',      'params_descr' => '',
            'script' => 'linux_metric_www_yslow.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 3600,   'include'=>0,
				'myrange' => 'www-check,[-n;IP;;2]',
      );
?>
