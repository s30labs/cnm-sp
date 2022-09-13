<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_003000',   'class' => 'proxy-linux',  'description' => 'MENSAJES EN BUZON IMAP4 - INBOX',
            'apptype' => 'CNM',  'itil_type' => '1',    'tag' => '001',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'Num mails in INBOX',        'vlabel' => 'Num Msgs',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '2',
            'params' => "[-host;Host;;2]:[-lapse;Lapse;300;0]",      'params_descr' => '',
            'script' => 'cnm_internal_core_metrics_001.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>0,
				'myrange' => '',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_003001',   'class' => 'proxy-linux',  'description' => 'CONECTIVIDAD AL BUZON IMAP4 - INBOX',
            'apptype' => 'CNM',  'itil_type' => '1',    'tag' => '002',   'esp'=>'MAP(0)(1,0,0,0,0)|MAP(1)(0,1,0,0,0)|MAP(2)(0,0,1,0,0)|MAP(3)(0,0,0,1,0)|MAP(4)(0,0,0,0,1)',  'iptab' => '1',
            'items' => 'OK(0)|Login(1)|Connect(2)|Credentials(3)|Config(4)',        'vlabel' => 'Status',      'mode' => 'GAUGE',
            'mtype' => 'STD_SOLID',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '2',
            'params' => "[-host;Host;;2]:[-lapse;Lapse;300;0]",      'params_descr' => '',
            'script' => 'cnm_internal_core_metrics_001.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>0,
				'myrange' => '',
      );
?>
