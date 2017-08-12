<?php

//---------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------
//mib2_if
//LISTA DE INTERFACES
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_mib2_listinterfaces', 'hparam' => '20000000', 'type' => 'snmp', 'enable' => '1', 'value' => '',
      'script' => 'mib2_if',
   );
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_mib2_listinterfaces', 'hparam' => '20000001', 'type' => 'snmp', 'enable' => '1', 'value' => 'json',
      'script' => 'mib2_if',
   );

//mibhost_disk
//USO DE DISCO(%)
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_mibhost_diskp', 'hparam' => '20000002', 'type' => 'snmp', 'enable' => '1', 'value' => '',
      'script' => 'mibhost_disk',
   );
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_mibhost_diskp', 'hparam' => '20000003', 'type' => 'snmp', 'enable' => '1', 'value' => 'json',
      'script' => 'mibhost_disk',
   );

//get_cdp
//REGISTRO DE VECINOS POR CDP
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_cisco_cdptable', 'hparam' => '20000004', 'type' => 'snmp', 'enable' => '1', 'value' => '',
      'script' => 'get_cdp',
   );
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_cisco_cdptable', 'hparam' => '20000005', 'type' => 'snmp', 'enable' => '1', 'value' => 'json',
      'script' => 'get_cdp',
   );

//cisco_ccm_device_pools
//DEVICE POOLS DEFINIDOS
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_cisco_ccm_dev_pool', 'hparam' => '20000006', 'type' => 'snmp', 'enable' => '1', 'value' => '',
      'script' => 'cisco_ccm_device_pools',
   );
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_cisco_ccm_dev_pool', 'hparam' => '20000007', 'type' => 'snmp', 'enable' => '1', 'value' => 'json',
      'script' => 'cisco_ccm_device_pools',
   );

?>
