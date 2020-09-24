<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_002000',   'class' => 'proxy-linux',  'description' => 'MONITORIZACION DEL DISPOSITIVO',
            'apptype' => 'CNM',  'itil_type' => '1',    'tag' => '001',   'esp'=>'MAP(0)(1,0,0,0)|MAP(2)(0,1,0,0)|MAP(1)(0,0,1,0)|MAP(3)(0,0,0,1)',  'iptab' => '1',
            'items' => 'Active(0)|Maintenance(2)|Inactive(1)|Unknown(3)',        'vlabel' => 'Status',      'mode' => 'GAUGE',
            'mtype' => 'STD_SOLID',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '1',
            'params' => '[-id;IP;;2]',      'params_descr' => '',
            'script' => 'cnm_metric_device_status.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>0,
				'myrange' => '',
      );
?>
