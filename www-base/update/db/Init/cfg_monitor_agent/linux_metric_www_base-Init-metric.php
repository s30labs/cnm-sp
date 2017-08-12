<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004620',   'class' => 'proxy-linux',  'description' => 'TEXTO SCRIPT EN PAGINA WEB',
            'apptype' => 'IPSERV.WWW',  'itil_type' => '1',    'tag' => '003',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'Number of Ocurrences',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '2',
            'params' => '[-ip;IP;;2]:[-pattern;PATRON;script;1]',      'params_descr' => '',
            'script' => 'linux_metric_www_base.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>0,
				'myrange' => 'www-check,[-ip;IP;;2]',
      );
?>
