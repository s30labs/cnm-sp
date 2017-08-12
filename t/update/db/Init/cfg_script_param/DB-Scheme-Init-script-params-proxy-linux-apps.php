<?php
/*

param_type => 0:Normal 1:Securizado 2:IP/HOST
position => Orden en que aparecen IMPORTANTE!!!!!
*/
//---------------------------------------------------------------------------------------------------------


//---------------------------------------------------------------------------------------------------------
// CNM
//---------------------------------------------------------------------------------------------------------
//audit
//AUDITORIA DE RED
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '10000002', 'position' => '0', 'param_type' => '0',
      'script' => 'audit',
      'prefix' => '-a', 'descr' => 'Rango', 'value' => '',
   );

//generate_report.php
//GENERADOR DE INFORMES
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '10000003', 'position' => '0', 'param_type' => '0',
      'script' => 'generate_report.php',
      'prefix' => '-e', 'descr' => 'Fecha fin (timestamp)', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '10000004', 'position' => '1', 'param_type' => '0',
      'script' => 'generate_report.php',
      'prefix' => '-s', 'descr' => 'Fecha inicio (timestamp)', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '10000005', 'position' => '2', 'param_type' => '0',
      'script' => 'generate_report.php',
      'prefix' => '-n', 'descr' => 'Nombre del informe', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '10000006', 'position' => '3', 'param_type' => '0',
      'script' => 'generate_report.php',
      'prefix' => '-i', 'descr' => 'Identificador', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '10000007', 'position' => '4', 'param_type' => '0',
      'script' => 'generate_report.php',
      'prefix' => '-h', 'descr' => 'Ayuda', 'value' => '',
   );


//ws_get_csv_view_metrics
//OBTENER LAS METRICAS DE UNA VISTA
//   $CFG_SCRIPT_PARAM[]=array(
//      'hparam' => '10000008', 'position' => '0', 'param_type' => '0',
//      'script' => 'ws_get_csv_view_metrics',
//      'prefix' => '-i', 'descr' => 'Identificador de la vista', 'value' => '1',
//   );

//linux_app_restore_passive_from_active.pl
//RESTAURAR DESDE UN BACKUP (LOCAL O REMOTO)
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '10000010', 'position' => '0', 'param_type' => '0',
      'script' => 'linux_app_restore_passive_from_active.pl',
      'prefix' => '-r', 'descr' => 'IP donde esta el backup', 'value' => 'localhost',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '10000012', 'position' => '2', 'param_type' => '1',
      'script' => 'linux_app_restore_passive_from_active.pl',
      'prefix' => '-u', 'descr' => 'Usuario', 'value' => 'cnm',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '10000013', 'position' => '3', 'param_type' => '1',
      'script' => 'linux_app_restore_passive_from_active.pl',
      'prefix' => '-p', 'descr' => 'Password/Passphrase', 'value' => 'cnm123',
   );





//---------------------------------------------------------------------------------------------------------
// SNMP
//---------------------------------------------------------------------------------------------------------
//mib2_if
//[-n;IP;;2]:[-w;Formato de salida;json;0]
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '20000000', 'position' => '0', 'param_type' => '2',
      'script' => 'mib2_if',
      'prefix' => '-n', 'descr' => 'IP', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '20000001', 'position' => '1', 'param_type' => '0',
      'script' => 'mib2_if',
      'prefix' => '-w', 'descr' => 'Formato de salida', 'value' => 'json',
   );

//mibhost_disk
//[-n;IP;;2]:[-w;Formato de salida;json;0]
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '20000002', 'position' => '0', 'param_type' => '2',
      'script' => 'mibhost_disk',
      'prefix' => '-n', 'descr' => 'IP', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '20000003', 'position' => '1', 'param_type' => '0',
      'script' => 'mibhost_disk',
      'prefix' => '-w', 'descr' => 'Formato de salida', 'value' => 'json',
   );

//get_cdp
//[-n;IP;;2]:[-w;Formato de salida;json;0]
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '20000004', 'position' => '0', 'param_type' => '2',
      'script' => 'get_cdp',
      'prefix' => '-n', 'descr' => 'IP', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '20000005', 'position' => '1', 'param_type' => '0',
      'script' => 'get_cdp',
      'prefix' => '-w', 'descr' => 'Formato de salida', 'value' => 'json',
   );

//cisco_ccm_device_pools
//[-n;IP;;2]:[-w;Formato de salida;json;0]
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '20000006', 'position' => '0', 'param_type' => '2',
      'script' => 'cisco_ccm_device_pools',
      'prefix' => '-n', 'descr' => 'IP', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '20000007', 'position' => '1', 'param_type' => '0',
      'script' => 'cisco_ccm_device_pools',
      'prefix' => '-w', 'descr' => 'Formato de salida', 'value' => 'json',
   );

//snmptable
// OJO si se cambiaran los valores de hparam, afecta a los datos de todas las apps snmp
// generadas por gconf !!
//[-n;IP;;2]:[-w;Formato de salida;json;0]
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '20000008', 'position' => '0', 'param_type' => '0',
      'script' => 'snmptable',
      'prefix' => '-f', 'descr' => 'Descriptor', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '20000009', 'position' => '1', 'param_type' => '0',
      'script' => 'snmptable',
      'prefix' => '-w', 'descr' => 'Formato de salida', 'value' => 'json',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '2000000a', 'position' => '2', 'param_type' => '2',
      'script' => 'snmptable',
      'prefix' => '-n', 'descr' => 'IP', 'value' => '',
   );


//---------------------------------------------------------------------------------------------------------
// LATENCY
//---------------------------------------------------------------------------------------------------------
//cnm-ping
//[-n;IP;;2]:[-o;Opciones del comando;;0]:[-w;Formato de salida;json;0]
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '30000000', 'position' => '0', 'param_type' => '2',
      'script' => 'cnm-ping',
      'prefix' => '-n', 'descr' => 'IP', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '30000001', 'position' => '1', 'param_type' => '0',
      'script' => 'cnm-ping',
      'prefix' => '-o', 'descr' => 'Opciones del comando', 'value' => '',
   );
/*
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '30000002', 'position' => '2', 'param_type' => '0',
      'script' => 'cnm-ping',
      'prefix' => '-w', 'descr' => 'Formato de salida', 'value' => 'json',
   );
*/
//cnm-traceroute
//[-n;IP;;2]:[-o;Opciones del comando;;0]:[-w;Formato de salida;json;0]
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '30000003', 'position' => '0', 'param_type' => '2',
      'script' => 'cnm-traceroute',
      'prefix' => '-n', 'descr' => 'IP', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '30000004', 'position' => '1', 'param_type' => '0',
      'script' => 'cnm-traceroute',
      'prefix' => '-o', 'descr' => 'Opciones del comando', 'value' => '',
   );
/*
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '30000005', 'position' => '2', 'param_type' => '0',
      'script' => 'cnm-traceroute',
      'prefix' => '-w', 'descr' => 'Formato de salida', 'value' => 'json',
   );
*/
//cnm-nmap
//[-n;IP;;2]:[-o;Opciones del comando;;0]:[-w;Formato de salida;json;0]
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '30000006', 'position' => '0', 'param_type' => '2',
      'script' => 'cnm-nmap',
      'prefix' => '-n', 'descr' => 'IP', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '30000007', 'position' => '1', 'param_type' => '0',
      'script' => 'cnm-nmap',
      'prefix' => '-o', 'descr' => 'Opciones del comando', 'value' => '',
   );
/*
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '30000008', 'position' => '2', 'param_type' => '0',
      'script' => 'cnm-nmap',
      'prefix' => '-w', 'descr' => 'Formato de salida', 'value' => 'json',
   );
*/
//mon_tcp
//[-n;IP;;2]:[-o;Opciones del comando;;0]:[-w;Formato de salida;json;0]
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '30000009', 'position' => '0', 'param_type' => '2',
      'script' => 'mon_tcp',
      'prefix' => '-n', 'descr' => 'IP', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '3000000a', 'position' => '1', 'param_type' => '0',
      'script' => 'mon_tcp',
      'prefix' => '-p', 'descr' => 'Puerto', 'value' => '',
   );


   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '30000010', 'position' => '0', 'param_type' => '2',
      'script' => 'cnm-sslcerts',
      'prefix' => '-n', 'descr' => 'IP', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '30000011', 'position' => '1', 'param_type' => '0',
      'script' => 'cnm-sslcerts',
      'prefix' => '-p', 'descr' => 'Puerto', 'value' => '443',
   );


   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '30000012', 'position' => '0', 'param_type' => '2',
      'script' => 'mon_smtp_ext',
      'prefix' => '-n', 'descr' => 'IP', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '30000013', 'position' => '1', 'param_type' => '0',
      'script' => 'mon_smtp_ext',
      'prefix' => '-p', 'descr' => 'Puerto', 'value' => '25',
   );


//---------------------------------------------------------------------------------------------------------
// PROXY
//---------------------------------------------------------------------------------------------------------
//linux_app_get_conf_telnet_comtrend_router.pl
//[-n;IP;;2]:[-u;Usuario;;1]:[-p;Clave;;1]
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '40000000', 'position' => '0', 'param_type' => '2',
      'script' => 'linux_app_get_conf_telnet_comtrend_router.pl',
      'prefix' => '-n', 'descr' => 'IP', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '40000001', 'position' => '1', 'param_type' => '1',
      'script' => 'linux_app_get_conf_telnet_comtrend_router.pl',
      'prefix' => '-u', 'descr' => 'Usuario', 'value' => '$sec.telnet.user',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '40000002', 'position' => '2', 'param_type' => '1',
      'script' => 'linux_app_get_conf_telnet_comtrend_router.pl',
      'prefix' => '-p', 'descr' => 'Clave', 'value' => '$sec.telnet.pwd',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '40000003', 'position' => '3', 'param_type' => '0',
      'script' => 'linux_app_get_conf_telnet_comtrend_router.pl',
      'prefix' => '-l', 'descr' => 'Limite de Ficheros', 'value' => '10',
   );

//linux_app_get_conf_telnet_cisco_router.pl
//[-n;IP;;2]:[-u;Usuario;;1]:[-p;Clave;;1]
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '40000010', 'position' => '0', 'param_type' => '2',
      'script' => 'linux_app_get_conf_telnet_cisco_router.pl',
      'prefix' => '-n', 'descr' => 'IP', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '40000011', 'position' => '1', 'param_type' => '1',
      'script' => 'linux_app_get_conf_telnet_cisco_router.pl',
      'prefix' => '-u', 'descr' => 'Usuario', 'value' => '$sec.telnet.user',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '40000012', 'position' => '2', 'param_type' => '1',
      'script' => 'linux_app_get_conf_telnet_cisco_router.pl',
      'prefix' => '-p', 'descr' => 'Clave', 'value' => '$sec.telnet.pwd',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '40000013', 'position' => '3', 'param_type' => '1',
      'script' => 'linux_app_get_conf_telnet_cisco_router.pl',
      'prefix' => '-e', 'descr' => 'Clave de Enable', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '40000014', 'position' => '4', 'param_type' => '0',
      'script' => 'linux_app_get_conf_telnet_cisco_router.pl',
      'prefix' => '-l', 'descr' => 'Limite de Ficheros', 'value' => '10',
   );

//linux_app_check_remote_cfgs.pl
//[-n;IP;;2]
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '40000020', 'position' => '0', 'param_type' => '2',
      'script' => 'linux_app_check_remote_cfgs.pl',
      'prefix' => '-n', 'descr' => 'IP', 'value' => '',
   );

?>
