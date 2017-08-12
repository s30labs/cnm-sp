<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004030',   'class' => 'proxy-linux',  'description' => 'IPMI - TEMPERATURA',
            'apptype' => 'HW.IPMI',  'itil_type' => '1',    'tag' => '001',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'Temperatura',        'vlabel' => 'ºC',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '6',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.ipmi.user;0]:[-p;Clave;$sec.ipmi.pwd;1]:[-t;Timeout;2;0]',      'params_descr' => '',
            'script' => 'linux_metric_ipmi_sensors.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'ipmi_sensors-check,[-n;IP;;2]:[-u;Usuario;$sec.ipmi.user;0]:[-p;Clave;$sec.ipmi.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004031',   'class' => 'proxy-linux',  'description' => 'IPMI - ESTADO DE LA CAJA',
            'apptype' => 'HW.IPMI',  'itil_type' => '1',    'tag' => '005',   'esp'=>'MAPS(\'ok\')(1,0)|MAPS(\'general chassis intrusion\')(0,1)',  'iptab' => '0',
            'items' => 'Cerrado|Abierto',        'vlabel' => 'Estado',      'mode' => 'GAUGE',
            'mtype' => 'STD_SOLID',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '6',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.ipmi.user;0]:[-p;Clave;$sec.ipmi.pwd;1]:[-t;Timeout;2;0]',      'params_descr' => '',
            'script' => 'linux_metric_ipmi_sensors.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'ipmi_sensors-check,[-n;IP;;2]:[-u;Usuario;$sec.ipmi.user;0]:[-p;Clave;$sec.ipmi.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004032',   'class' => 'proxy-linux',  'description' => 'IPMI - VENTILADOR',
            'apptype' => 'HW.IPMI',  'itil_type' => '1',    'tag' => '004',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'RPM',        'vlabel' => 'RPM',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '6',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.ipmi.user;0]:[-p;Clave;$sec.ipmi.pwd;1]:[-t;Timeout;2;0]',      'params_descr' => '',
            'script' => 'linux_metric_ipmi_sensors.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'ipmi_sensors-check,[-n;IP;;2]:[-u;Usuario;$sec.ipmi.user;0]:[-p;Clave;$sec.ipmi.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004033',   'class' => 'proxy-linux',  'description' => 'IPMI - VOLTAJE',
            'apptype' => 'HW.IPMI',  'itil_type' => '1',    'tag' => '002',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'V',        'vlabel' => 'V',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '6',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.ipmi.user;0]:[-p;Clave;$sec.ipmi.pwd;1]:[-t;Timeout;2;0]',      'params_descr' => '',
            'script' => 'linux_metric_ipmi_sensors.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'ipmi_sensors-check,[-n;IP;;2]:[-u;Usuario;$sec.ipmi.user;0]:[-p;Clave;$sec.ipmi.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004034',   'class' => 'proxy-linux',  'description' => 'IPMI - ESTADO DEL SERVICIO',
            'apptype' => 'HW.IPMI',  'itil_type' => '1',    'tag' => '100',   'esp'=>'MAP(1)(1,0)|MAP(0)(0,1)',  'iptab' => '0',
            'items' => 'Ok|Nook',        'vlabel' => 'Estado',      'mode' => 'GAUGE',
            'mtype' => 'STD_SOLID',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '6',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.ipmi.user;0]:[-p;Clave;$sec.ipmi.pwd;1]:[-t;Timeout;2;0]',      'params_descr' => '',
            'script' => 'linux_metric_ipmi_sensors.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'ipmi_sensors-check,[-n;IP;;2]:[-u;Usuario;$sec.ipmi.user;0]:[-p;Clave;$sec.ipmi.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004035',   'class' => 'proxy-linux',  'description' => 'IPMI - ESTADO DEL DISPOSITIVO',
            'apptype' => 'HW.IPMI',  'itil_type' => '1',    'tag' => '200',   'esp'=>'MAP(1)(0,0,1)|MAP(2)(0,1,0)|MAP(0)(1,0,0)',  'iptab' => '0',
            'items' => 'Encendido|Desconocido|Apagado',        'vlabel' => '',      'mode' => 'GAUGE',
            'mtype' => 'STD_SOLID',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '6',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.ipmi.user;0]:[-p;Clave;$sec.ipmi.pwd;1]:[-t;Timeout;2;0]',      'params_descr' => '',
            'script' => 'linux_metric_ipmi_sensors.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'ipmi_sensors-check,[-n;IP;;2]:[-u;Usuario;$sec.ipmi.user;0]:[-p;Clave;$sec.ipmi.pwd;1]',
      );
?>
