<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004700',   'class' => 'proxy-linux',  'description' => 'DOCKER - CONTENEDORES',
            'apptype' => 'SO.DOCKER',  'itil_type' => '1',    'tag' => '001|002|003',   'esp'=>'o1|o2|o3',  'iptab' => '1',
            'items' => 'Running|RIP|Other',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '1',
            'params' => '[-n;IP;;2]',      'params_descr' => '',
            'script' => 'linux_metric_ssh_docker.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>0,
				'myrange' => 'ssh-check,[-n;IP;;2]',
      );
?>
