<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004511',   'class' => 'proxy-linux',  'description' => 'WMI - SERVICIO SNMP',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => '200.SNMP',   'esp'=>'MAP(1)(1,0,0,0,0,0,0,0)|MAP(2)(0,1,0,0,0,0,0,0)|MAP(3)(0,0,1,0,0,0,0,0)|MAP(4)(0,0,0,1,0,0,0,0)|MAP(5)(0,0,0,0,1,0,0,0)|MAP(6)(0,0,0,0,0,1,0,0)|MAP(7)(0,0,0,0,0,0,1,0)|MAP(8)(0,0,0,0,0,0,0,1)',  'iptab' => '1',
            'items' => 'Running(1)|Unknown(2)|Stopped(3)|Start Pending(4)|Stop Pending(5)|Continue Pending(6)|Pause Pending(7)|Paused(8)',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_SOLID',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '4',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]:[-i;Indice;Name;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_services.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004510',   'class' => 'proxy-linux',  'description' => 'WMI - SERVICIO',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => '200',   'esp'=>'MAP(1)(1,0,0,0,0,0,0,0)|MAP(2)(0,1,0,0,0,0,0,0)|MAP(3)(0,0,1,0,0,0,0,0)|MAP(4)(0,0,0,1,0,0,0,0)|MAP(5)(0,0,0,0,1,0,0,0)|MAP(6)(0,0,0,0,0,1,0,0)|MAP(7)(0,0,0,0,0,0,1,0)|MAP(8)(0,0,0,0,0,0,0,1)',  'iptab' => '1',
            'items' => 'Running(1)|Unknown(2)|Stopped(3)|Start Pending(4)|Stop Pending(5)|Continue Pending(6)|Pause Pending(7)|Paused(8)',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_SOLID',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '4',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]:[-i;Indice;Name;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_services.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
?>
