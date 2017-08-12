<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004600',   'class' => 'proxy-linux',  'description' => 'WEB PAGE LOAD TIME',
            'apptype' => 'IPSERV.WWW',  'itil_type' => '1',    'tag' => '041|042',   'esp'=>'o1|o2',  'iptab' => '1',
            'items' => 'onLoad Time|onContentLoad Time',        'vlabel' => 'Segs',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '1',
            'params' => '[-n;IP;;2]',      'params_descr' => '',
            'script' => 'linux_metric_www_perf.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>0,
				'myrange' => 'www-check,[-n;IP;;2]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004601',   'class' => 'proxy-linux',  'description' => 'WEB PAGE RESPONSE CODES',
            'apptype' => 'IPSERV.WWW',  'itil_type' => '1',    'tag' => '010|011|012|013',   'esp'=>'o1|o2|o3|o4',  'iptab' => '1',
            'items' => 'Code 200|Code 4xx|Code 5xx|Other Codes',        'vlabel' => 'Number',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '1',
            'params' => '[-n;IP;;2]',      'params_descr' => '',
            'script' => 'linux_metric_www_perf.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>0,
				'myrange' => 'www-check,[-n;IP;;2]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004602',   'class' => 'proxy-linux',  'description' => 'WEB PAGE RESOURCES',
            'apptype' => 'IPSERV.WWW',  'itil_type' => '1',    'tag' => '020|021|022|023|024|025|026',   'esp'=>'o1|o2|o3|o4|o5|o6|o7',  'iptab' => '1',
            'items' => 'Total|HTML|Javascript|CSS|Image|Text|Other',        'vlabel' => 'Number',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '1',
            'params' => '[-n;IP;;2]',      'params_descr' => '',
            'script' => 'linux_metric_www_perf.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>0,
				'myrange' => 'www-check,[-n;IP;;2]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004603',   'class' => 'proxy-linux',  'description' => 'WEB PAGE SIZE',
            'apptype' => 'IPSERV.WWW',  'itil_type' => '1',    'tag' => '030|031|032|033|034|035|036',   'esp'=>'o1|o2|o3|o4|o5|o6|o7',  'iptab' => '1',
            'items' => 'Total|HTML|Javascript|CSS|Image|Text|Other',        'vlabel' => 'Number',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '1',
            'params' => '[-n;IP;;2]',      'params_descr' => '',
            'script' => 'linux_metric_www_perf.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>0,
				'myrange' => 'www-check,[-n;IP;;2]',
      );
?>
