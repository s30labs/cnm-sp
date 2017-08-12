<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004520',   'class' => 'proxy-linux',  'description' => 'VMWARE - USO DE CPU',
            'apptype' => 'VIRTUAL.VMWARE',  'itil_type' => '1',    'tag' => '101',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'Uso (%)',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]:[-P;Port;443;0]:[-H;Host;;0]',      'params_descr' => '',
            'script' => 'linux_metric_vmware_performance.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'vmware-check,[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004521',   'class' => 'proxy-linux',  'description' => 'VMWARE - USO DETALLADO DE MEMORIA',
            'apptype' => 'VIRTUAL.VMWARE',  'itil_type' => '1',    'tag' => '201|202|203|204|205',   'esp'=>'o1|o2|o3|o4|o5',  'iptab' => '1',
            'items' => 'Consumed (kB)|Overhead (kB)|Shared (kB)|Swap used (kB)|Balloon (kB)',        'vlabel' => 'KB',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]:[-P;Port;443;0]:[-H;Host;;0]',      'params_descr' => '',
            'script' => 'linux_metric_vmware_performance.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'vmware-check,[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004522',   'class' => 'proxy-linux',  'description' => 'VMWARE - ESTADO DE LA MEMORIA',
            'apptype' => 'VIRTUAL.VMWARE',  'itil_type' => '1',    'tag' => '206',   'esp'=>'MAP(0)(1,0,0,0)|MAP(1)(0,1,0,0)|MAP(2)(0,0,1,0)|MAP(3)(0,0,0,1)',  'iptab' => '1',
            'items' => 'high(0)|soft(1)|hard(2)|low(3)',        'vlabel' => 'KB',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]:[-P;Port;443;0]:[-H;Host;;0]',      'params_descr' => '',
            'script' => 'linux_metric_vmware_performance.pl',         'severity' => '1',
            'cfg' => '1',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'vmware-check,[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004530',   'class' => 'proxy-linux',  'description' => 'VMWARE - USO DE DATASTORE',
            'apptype' => 'VIRTUAL.VMWARE',  'itil_type' => '1',    'tag' => '500|501|502',   'esp'=>'o2|o1|o3',  'iptab' => '1',
            'items' => 'Espacio Total|Espacio Libre|Usado(%)',        'vlabel' => 'MB',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]:[-P;Port;443;0]:[-H;Host;;0]',      'params_descr' => '',
            'script' => 'linux_metric_vmware_performance.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'vmware-check,[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004531',   'class' => 'proxy-linux',  'description' => 'VMWARE - ERRORES EN DISCO',
            'apptype' => 'VIRTUAL.VMWARE',  'itil_type' => '1',    'tag' => '300|301',   'esp'=>'o1|o2',  'iptab' => '1',
            'items' => 'Commands aborted|Bus resets',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]:[-P;Port;443;0]:[-H;Host;;0]',      'params_descr' => '',
            'script' => 'linux_metric_vmware_performance.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'vmware-check,[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004532',   'class' => 'proxy-linux',  'description' => 'VMWARE - LATENCIA EN DISCO',
            'apptype' => 'VIRTUAL.VMWARE',  'itil_type' => '1',    'tag' => '308|309|310',   'esp'=>'o1|o2|o3',  'iptab' => '1',
            'items' => 'Read latency|Write latency|Command latency',        'vlabel' => 'ms',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]:[-P;Port;443;0]:[-H;Host;;0]',      'params_descr' => '',
            'script' => 'linux_metric_vmware_performance.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'vmware-check,[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004533',   'class' => 'proxy-linux',  'description' => 'VMWARE - LATENCIA (Q) EN DISCO',
            'apptype' => 'VIRTUAL.VMWARE',  'itil_type' => '1',    'tag' => '302|303|304',   'esp'=>'o1|o2|o3',  'iptab' => '1',
            'items' => 'Queue read latency|Queue write latency|Queue command latency',        'vlabel' => 'ms',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]:[-P;Port;443;0]:[-H;Host;;0]',      'params_descr' => '',
            'script' => 'linux_metric_vmware_performance.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'vmware-check,[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004534',   'class' => 'proxy-linux',  'description' => 'VMWARE - LATENCIA (K) EN DISCO',
            'apptype' => 'VIRTUAL.VMWARE',  'itil_type' => '1',    'tag' => '305|306|307',   'esp'=>'o1|o2|o3',  'iptab' => '1',
            'items' => 'Kernel read latency|Kernel write latency|Kernel command latency',        'vlabel' => 'ms',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]:[-P;Port;443;0]:[-H;Host;;0]',      'params_descr' => '',
            'script' => 'linux_metric_vmware_performance.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'vmware-check,[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004535',   'class' => 'proxy-linux',  'description' => 'VMWARE - LATENCIA (Phys) EN DISCO',
            'apptype' => 'VIRTUAL.VMWARE',  'itil_type' => '1',    'tag' => '311|312|313',   'esp'=>'o1|o2|o3',  'iptab' => '1',
            'items' => 'Physical device read latency|Physical device write latency|Physical device  command latency',        'vlabel' => 'ms',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]:[-P;Port;443;0]:[-H;Host;;0]',      'params_descr' => '',
            'script' => 'linux_metric_vmware_performance.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'vmware-check,[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004536',   'class' => 'proxy-linux',  'description' => 'VMWARE - TRAFICO',
            'apptype' => 'VIRTUAL.VMWARE',  'itil_type' => '1',    'tag' => '400|401|402|403|404|405',   'esp'=>'o1|o2|o3|o4|o5|o6',  'iptab' => '1',
            'items' => 'Packets transmitted|Packets received|Broadcast transmits|Broadcast receives|Multicast transmits|Multicast receives',        'vlabel' => 'pkts',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]:[-P;Port;443;0]:[-H;Host;;0]',      'params_descr' => '',
            'script' => 'linux_metric_vmware_performance.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'vmware-check,[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004537',   'class' => 'proxy-linux',  'description' => 'VMWARE - ERRORES DE RED',
            'apptype' => 'VIRTUAL.VMWARE',  'itil_type' => '1',    'tag' => '406|407|408|409',   'esp'=>'o1|o2|o3|o4',  'iptab' => '1',
            'items' => 'Packet transmit errors|Packet receive errors|Transmit packets dropped|Receive packets dropped',        'vlabel' => 'pkts',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]:[-P;Port;443;0]:[-H;Host;;0]',      'params_descr' => '',
            'script' => 'linux_metric_vmware_performance.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'vmware-check,[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]',
      );
?>
