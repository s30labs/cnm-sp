<?php
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_00453f',   'class' => 'proxy-linux',  'description' => 'VMWARE - ESTADO DE LA ALIMENTACION DE LAS VMs',
            'apptype' => 'VIRTUAL.VMWARE',  'itil_type' => '1',    'tag' => '101|102|103',   'esp'=>'o1|o2|o3',  'iptab' => '1',
            'items' => 'powerOnSummary|suspendedSummary|poweredOffSummary',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]:[-P;Port;443;0]',      'params_descr' => '',
            'script' => 'linux_metric_vmware_vminfo.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'vmware-check,[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_00453e',   'class' => 'proxy-linux',  'description' => 'VMWARE - ESTADO DE LA CONEXION DE LAS VMs',
            'apptype' => 'VIRTUAL.VMWARE',  'itil_type' => '1',    'tag' => '105|106|107',   'esp'=>'o1|o2|o3',  'iptab' => '1',
            'items' => 'connectedSummary|disconnectedSummary|notRespondingSummary',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_AREA',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]:[-P;Port;443;0]',      'params_descr' => '',
            'script' => 'linux_metric_vmware_vminfo.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'vmware-check,[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004540',   'class' => 'proxy-linux',  'description' => 'VMWARE - ESTADO (ENERGIA) DE VM',
            'apptype' => 'VIRTUAL.VMWARE',  'itil_type' => '1',    'tag' => '100',   'esp'=>'MAP(1)(1,0,0)|MAP(2)(0,1,0)|MAP(3)(0,0,1)',  'iptab' => '1',
            'items' => 'poweredOn(1)|suspended(2)|poweredOff(3)',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_SOLID',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]:[-P;Port;443;0]',      'params_descr' => '',
            'script' => 'linux_metric_vmware_vminfo.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'vmware-check,[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004541',   'class' => 'proxy-linux',  'description' => 'VMWARE - ESTADO (CONEX) DE VM',
            'apptype' => 'VIRTUAL.VMWARE',  'itil_type' => '1',    'tag' => '104',   'esp'=>'MAP(1)(1,0,0)|MAP(2)(0,1,0)|MAP(3)(0,0,1)',  'iptab' => '1',
            'items' => 'connected(1)|disconnected(2)|notResponding(3)',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_SOLID',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]:[-P;Port;443;0]',      'params_descr' => '',
            'script' => 'linux_metric_vmware_vminfo.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'vmware-check,[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]',
      );
      $CFG_MONITOR_AGENT[]=array(
            'subtype' => 'xagt_004542',   'class' => 'proxy-linux',  'description' => 'VMWARE - CONEXIONES MKS DE VM',
            'apptype' => 'VIRTUAL.VMWARE',  'itil_type' => '1',    'tag' => '110',   'esp'=>'o1',  'iptab' => '1',
            'items' => 'numMksConnections',        'vlabel' => 'Num',      'mode' => 'GAUGE',
            'mtype' => 'STD_SOLID',        'top_value' => '1',     'module' => 'mod_xagent_get',    'nparams' => '5',
            'params' => '[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]:[-P;Port;443;0]',      'params_descr' => '',
            'script' => 'linux_metric_vmware_vminfo.pl',         'severity' => '1',
            'cfg' => '2',  'custom' => '0',  'get_iid' => '0',  'proxy'=>1, 'proxy_type'=>'linux',
            'info' => '',  'lapse' => 300,   'include'=>1,
				'myrange' => 'vmware-check,[-n;IP;;2]:[-u;Usuario;$sec.vmware.user;1]:[-p;Clave;$sec.vmware.pwd;1]',
      );
?>
