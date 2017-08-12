<?php

   $CFG_REMOTE_ALERTS[]=array(
      'type' => 'snmp',     'subtype' => 'CNM-NOTIFICATIONS-MIB::cnmNotifNoLinkSet',      'hiid' => '1a8f9efa98',
      'descr' => 'EL INTERFAZ DE RED NO TIENE LINK',    'mode'=>'INC',    'expr'=>'AND',
		'vardata' =>'cnmNotifCode;cnmNotifMsg;cnmNotifKey',
      'monitor' => '',     'vdata' => '', 'severity' => '1',   'action' => 'SET',   'script' => '', 'enterprise' => 'ent.34225',
      'apptype' => 'CNM', 'itil_type' => '1', 'class'=>'CNM', 'include'=>'1',
		
      'cfg_remote_alerts2expr' => array ( 'id'=>'id_remote_alert',
				array('v'=>'v1', 'descr'=>'cnmNotifCode', 'fx'=>'MATCH',  'expr'=>''),
array('v'=>'v2', 'descr'=>'cnmNotifMsg', 'fx'=>'MATCH',  'expr'=>''),
array('v'=>'v3', 'descr'=>'cnmNotifKey', 'fx'=>'MATCH',  'expr'=>'')
      )
   );



   $CFG_REMOTE_ALERTS[]=array(
      'type' => 'snmp',     'subtype' => 'CNM-NOTIFICATIONS-MIB::cnmNotiIFDownfSet',      'hiid' => '1a8f9efa98',
      'descr' => 'EL INTERFAZ DE RED ESTA CAIDO',    'mode'=>'INC',    'expr'=>'AND',
		'vardata' =>'cnmNotifCode;cnmNotifMsg;cnmNotifKey',
      'monitor' => '',     'vdata' => '', 'severity' => '1',   'action' => 'SET',   'script' => '', 'enterprise' => 'ent.34225',
      'apptype' => 'CNM', 'itil_type' => '1', 'class'=>'CNM', 'include'=>'1',
		
      'cfg_remote_alerts2expr' => array ( 'id'=>'id_remote_alert',
				array('v'=>'v1', 'descr'=>'cnmNotifCode', 'fx'=>'MATCH',  'expr'=>''),
array('v'=>'v2', 'descr'=>'cnmNotifMsg', 'fx'=>'MATCH',  'expr'=>''),
array('v'=>'v3', 'descr'=>'cnmNotifKey', 'fx'=>'MATCH',  'expr'=>'')
      )
   );



   $CFG_REMOTE_ALERTS[]=array(
      'type' => 'snmp',     'subtype' => 'CNM-NOTIFICATIONS-MIB::cnmNotifMCNMNoAccessToRemote',      'hiid' => '1a8f9efa98',
      'descr' => 'SIN ACCESO A CNM REMOTO',    'mode'=>'INC',    'expr'=>'AND',
		'vardata' =>'cnmNotifCode;cnmNotifMsg;cnmNotifKey',
      'monitor' => '',     'vdata' => '', 'severity' => '1',   'action' => 'SET',   'script' => '', 'enterprise' => 'ent.34225',
      'apptype' => 'CNM', 'itil_type' => '1', 'class'=>'CNM', 'include'=>'1',
		
      'cfg_remote_alerts2expr' => array ( 'id'=>'id_remote_alert',
				array('v'=>'v1', 'descr'=>'cnmNotifCode', 'fx'=>'MATCH',  'expr'=>''),
array('v'=>'v2', 'descr'=>'cnmNotifMsg', 'fx'=>'MATCH',  'expr'=>''),
array('v'=>'v3', 'descr'=>'cnmNotifKey', 'fx'=>'MATCH',  'expr'=>'')
      )
   );



   $CFG_REMOTE_ALERTS[]=array(
      'type' => 'snmp',     'subtype' => 'CNM-NOTIFICATIONS-MIB::cnmNotifMCNMBackupFailure',      'hiid' => '1a8f9efa98',
      'descr' => 'ERROR AL HACER EL BACKUP DEL EQUIPO',    'mode'=>'INC',    'expr'=>'AND',
		'vardata' =>'cnmNotifCode;cnmNotifMsg;cnmNotifKey',
      'monitor' => '',     'vdata' => '', 'severity' => '1',   'action' => 'SET',   'script' => '', 'enterprise' => 'ent.34225',
      'apptype' => 'CNM', 'itil_type' => '1', 'class'=>'CNM', 'include'=>'1',
		
      'cfg_remote_alerts2expr' => array ( 'id'=>'id_remote_alert',
				array('v'=>'v1', 'descr'=>'cnmNotifCode', 'fx'=>'MATCH',  'expr'=>''),
array('v'=>'v2', 'descr'=>'cnmNotifMsg', 'fx'=>'MATCH',  'expr'=>''),
array('v'=>'v3', 'descr'=>'cnmNotifKey', 'fx'=>'MATCH',  'expr'=>'')
      )
   );



   $CFG_REMOTE_ALERTS[]=array(
      'type' => 'snmp',     'subtype' => 'CNM-NOTIFICATIONS-MIB::cnmNotifNTPSyncFailure',      'hiid' => '1a8f9efa98',
      'descr' => 'ERROR AL SINCRONIZAR LA HORA DEL EQUIPO (NTP)',    'mode'=>'INC',    'expr'=>'AND',
		'vardata' =>'cnmNotifCode;cnmNotifMsg;cnmNotifKey',
      'monitor' => '',     'vdata' => '', 'severity' => '2',   'action' => 'SET',   'script' => '', 'enterprise' => 'ent.34225',
      'apptype' => 'CNM', 'itil_type' => '1', 'class'=>'CNM', 'include'=>'1',
		
      'cfg_remote_alerts2expr' => array ( 'id'=>'id_remote_alert',
				array('v'=>'v1', 'descr'=>'cnmNotifCode', 'fx'=>'MATCH',  'expr'=>''),
array('v'=>'v2', 'descr'=>'cnmNotifMsg', 'fx'=>'MATCH',  'expr'=>''),
array('v'=>'v3', 'descr'=>'cnmNotifKey', 'fx'=>'MATCH',  'expr'=>'')
      )
   );


?>
