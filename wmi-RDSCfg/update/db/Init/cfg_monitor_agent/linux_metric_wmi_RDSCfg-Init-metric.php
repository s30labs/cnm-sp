<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004515',   'class' => 'proxy-linux',  'description' => 'WMI - SESIONES REMOTAS',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => 'TotalSessions|DisconnectedSessions',   'esp'=>'o1|o2',  'iptab' => '1',
            'items' => 'TotalSessions|DisconnectedSessions',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_RDSCfg.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
?>
