<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004513',   'class' => 'proxy-linux',  'description' => 'WMI - DISCO C:',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => '201.C:|202.C:|200.C:|203.C:',   'esp'=>'o1|o2|o3|o4',  'iptab' => '1',
            'items' => 'Espacio Total|Espacio Usado|Espacio Libre|Usado(%)',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '4',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]:[-i;Indice;Name;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_disk.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004512',   'class' => 'proxy-linux',  'description' => 'WMI - DISCO',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => '201|202|200|203',   'esp'=>'o1|o2|o3|o4',  'iptab' => '1',
            'items' => 'Espacio Total|Espacio Usado|Espacio Libre|Usado(%)',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '4',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]:[-i;Indice;Name;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_disk.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
?>
