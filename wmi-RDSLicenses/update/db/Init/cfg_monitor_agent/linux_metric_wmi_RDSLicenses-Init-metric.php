<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_00451A',   'class' => 'proxy-linux',  'description' => 'WMI - LICENCIAS RDS POR ESTADO',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => '001.ACTIVE|001.CONCURRENT|001.PENDING|001.REVOKED|001.TEMP|001.UNK|001.UPGRADE',   'esp'=>'o1|o2|o3|o4|o5|o6|o7',  'iptab' => '1',
            'items' => 'Active|Concurrent|Pending|Revoked|Temp|Unknown|Upgrade',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_RDSLicenses.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_00451B',   'class' => 'proxy-linux',  'description' => 'WMI - LICENCIAS RDS ACTIVAS',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => '002.total|002.sIssuedToUser|002.sIssuedToComputer',   'esp'=>'o1|o2|o3',  'iptab' => '1',
            'items' => 'Total|sIssuedToUser|sIssuedToComputer',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_RDSLicenses.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
?>
