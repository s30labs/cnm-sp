<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004020',   'class' => 'proxy-linux',  'description' => 'DISPONIBILIDAD ICMP DUAL (sample)',
            'apptype' => 'IPSERV.BASE',  'itil_type' => '1',    'tag' => '003',   'esp'=>'MAP(0)(1,0,0,0,0)|MAP(4)(0,1,0,0,0)|MAP(3)(0,0,1,0,0)|MAP(2)(0,0,0,1,0)|MAP(1)(0,0,0,0,1)',  'iptab' => '0',
            'items' => 'ip1=ip2=ok(1)|unk(4)|ip1=ip2=nok(3)|ip1=nok ip2=ok(2)|ip1=ok ip2=nok(1)',        'vlabel' => '',      'mode' => 'GAUGE',
            'mtype' => 'STD_SOLID',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '2',
            'params' => '[-n;IP;;2]:[-s;Campo con IP2;;0]',      'params_descr' => '',
            'script' => 'linux_metric_icmp_dual.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'icmp_dual-check,[-n;IP;;2]:[-s;Campo con IP2;;0]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004021',   'class' => 'proxy-linux',  'description' => 'SERVICIO ICMP DUAL (sample)',
            'apptype' => 'IPSERV.BASE',  'itil_type' => '1',    'tag' => '001.ip1|001.ip2',   'esp'=>'o1|o2',  'iptab' => '0',
            'items' => 'Tiempo de Respuesta IP1|Tiempo de Respuesta IP2',        'vlabel' => '',      'mode' => 'GAUGE',
            'mtype' => 'STD_BASE',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '2',
            'params' => '[-n;IP;;2]:[-s;Campo con IP2;;0]',      'params_descr' => '',
            'script' => 'linux_metric_icmp_dual.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'icmp_dual-check,[-n;IP;;2]:[-s;Campo con IP2;;0]',
      );
?>
