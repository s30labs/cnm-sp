<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004500',   'class' => 'proxy-linux',  'description' => 'WMI - PROCESOS',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => 'Processes',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'Processes',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_perfOS.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004501',   'class' => 'proxy-linux',  'description' => 'WMI - THREADS',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => 'Threads',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'Threads',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_perfOS.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004502',   'class' => 'proxy-linux',  'description' => 'WMI - LLAMADAS AL SO',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => 'SystemCallsPersec',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'SystemCallsPersec',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_perfOS.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004503',   'class' => 'proxy-linux',  'description' => 'WMI - CAMBIOS DE CONTEXTO',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => 'ContextSwitchesPersec',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'ContextSwitchesPersec',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_perfOS.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004504',   'class' => 'proxy-linux',  'description' => 'WMI - COLA DE PROCESO',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => 'ProcessorQueueLength',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'ProcessorQueueLength',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_perfOS.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004505',   'class' => 'proxy-linux',  'description' => 'WMI - USO DE CPU',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => 'PercentProcessorTime',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'PercentProcessorTime',        'vlabel' => 'Perc',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_perfOS.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004506',   'class' => 'proxy-linux',  'description' => 'WMI - PAGINACION DE MEMORIA',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => 'PagesPersec|PageFaultsPersec',   'esp'=>'o1|o2',  'iptab' => '1',
            'items' => 'PagesPersec|PageFaultsPersec',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_perfOS.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004508',   'class' => 'proxy-linux',  'description' => 'WMI - USO DE MEMORIA',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => 'TotalPhysicalMemory|AvailableBytes',   'esp'=>'o1|o2',  'iptab' => '1',
            'items' => 'TotalPhysicalMemory (Bytes)|AvailableBytes (Bytes)',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '3',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_perfOS.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
?>
