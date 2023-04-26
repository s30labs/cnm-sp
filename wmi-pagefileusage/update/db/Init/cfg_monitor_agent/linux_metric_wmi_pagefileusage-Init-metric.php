<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004507',   'class' => 'proxy-linux',  'description' => 'WMI - USO DE C:\PAGEFILE.SYS',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => 'AllocatedBaseSize.C|CurrentUsage.C|PeakUsage.C',   'esp'=>'o1|o2|o3',  'iptab' => '1',
            'items' => 'AllocatedBaseSize (MB)|CurrentUsage (MB)|PeakUsage (MB)',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]:[-i;Indice;Name;1]:[-f;Filter;C:\pagefile.sys;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_pagefileusage.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004516',   'class' => 'proxy-linux',  'description' => 'WMI - USO DE D:\PAGEFILE.SYS',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => 'AllocatedBaseSize.D|CurrentUsage.D|PeakUsage.D',   'esp'=>'o1|o2|o3',  'iptab' => '1',
            'items' => 'AllocatedBaseSize (MB)|CurrentUsage (MB)|PeakUsage (MB)',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]:[-i;Indice;Name;1]:[-f;Filter;D:\pagefile.sys;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_pagefileusage.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004517',   'class' => 'proxy-linux',  'description' => 'WMI - USO DE E:\PAGEFILE.SYS',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => 'AllocatedBaseSize.E|CurrentUsage.E|PeakUsage.E',   'esp'=>'o1|o2|o3',  'iptab' => '1',
            'items' => 'AllocatedBaseSize (MB)|CurrentUsage (MB)|PeakUsage (MB)',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]:[-i;Indice;Name;1]:[-f;Filter;E:\pagefile.sys;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_pagefileusage.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004514',   'class' => 'proxy-linux',  'description' => 'WMI - FICHERO DE PAGINACION',
            'apptype' => 'SO.WINDOWS',  'itil_type' => '1',    'tag' => 'AllocatedBaseSize|CurrentUsage|PeakUsage',   'esp'=>'o1|o2|o3',  'iptab' => '1',
            'items' => 'AllocatedBaseSize (MB)|CurrentUsage (MB)|PeakUsage (MB)',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREAD',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]:[-i;Indice;Name;1][-f;Filter;;1]',      'params_descr' => '',
            'script' => 'linux_metric_wmi_pagefileusage.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'wmi-check,[-n;IP;;2]:[-u;Usuario;$sec.wmi.user;1]:[-p;Clave;$sec.wmi.pwd;1]',
      );
?>
