<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_647cba',   'class' => 'proxy-linux',  'description' => 'WMI - NUMERO DE EVENTOS ALMACENADOS',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => 'NumberOfRecords',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'NumberOfRecords',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_EventLog.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_ac18b2',   'class' => 'proxy-linux',  'description' => 'WMI - TAMAÑO DEL VISOR DE EVENTOS',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => 'FileSize',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'FileSize',        'vlabel' => 'Size',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_EventLog.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
?>
