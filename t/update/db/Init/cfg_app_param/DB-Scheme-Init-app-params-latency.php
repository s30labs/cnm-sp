<?php

//---------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------
//cnm-ping
//PING-10 /bin/ping -c 10
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_icmp_ping10', 'hparam' => '30000000', 'type' => 'latency', 'enable' => '1', 'value' => '',
      'script' => 'cnm-ping',
   );
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_icmp_ping10', 'hparam' => '30000001', 'type' => 'latency', 'enable' => '1', 'value' => '"-c 10"',
      'script' => 'cnm-ping',
   );

//cnm-ping
//PING-10 (largo) /bin/ping -c 10 -s 1024
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_icmp_ping1024', 'hparam' => '30000000', 'type' => 'latency', 'enable' => '1', 'value' => '',
      'script' => 'cnm-ping',
   );
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_icmp_ping1024', 'hparam' => '30000001', 'type' => 'latency', 'enable' => '1', 'value' => '"-c 10 -s 1024"',
      'script' => 'cnm-ping',
   );

//cnm-traceroute
//TRACEROUTE
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_tcp_traceroute', 'hparam' => '30000003', 'type' => 'latency', 'enable' => '1', 'value' => '',
      'script' => 'cnm-traceroute',
   );
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_tcp_traceroute', 'hparam' => '30000004', 'type' => 'latency', 'enable' => '1', 'value' => '',
      'script' => 'cnm-traceroute',
   );

//mon_tcp
//MONITOR TCP
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_tcp_monitor', 'hparam' => '30000009', 'type' => 'latency', 'enable' => '1', 'value' => '',
      'script' => 'mon_tcp',
   );

   $CFG_APP_PARAM[]=array(
      'aname' => 'app_tcp_monitor', 'hparam' => '3000000a', 'type' => 'latency', 'enable' => '1', 'value' => '',
      'script' => 'mon_tcp',
   );

//mon_smtp_ext
//MONITOR SMTP
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_smtp_monitor', 'hparam' => '30000012', 'type' => 'latency', 'enable' => '1', 'value' => '',
      'script' => 'mon_smtp_ext',
   );

   $CFG_APP_PARAM[]=array(
      'aname' => 'app_smtp_monitor', 'hparam' => '30000013', 'type' => 'latency', 'enable' => '1', 'value' => '25',
      'script' => 'mon_smtp_ext',
   );

//cnm-nmap
//ESCANEO DE PUERTOS /usr/bin/sudo /usr/bin/nmap -sS -T4 -p 1-10000
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_tcp_scanports', 'hparam' => '30000006', 'type' => 'latency', 'enable' => '1', 'value' => '',
      'script' => 'cnm-nmap',
   );
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_tcp_scanports', 'hparam' => '30000007', 'type' => 'latency', 'enable' => '1', 'value' => '"-sS -T4 -p 1-10000"',
      'script' => 'cnm-nmap',
   );

//cnm-nmap
//ESCANEO DE SISTEMA OPERATIVO /usr/bin/sudo /usr/bin/nmap  -A -T4 -p 21,22,111,135,139,445,35879
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_tcp_scanso', 'hparam' => '30000006', 'type' => 'latency', 'enable' => '1', 'value' => '',
      'script' => 'cnm-nmap',
   );
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_tcp_scanso', 'hparam' => '30000007', 'type' => 'latency', 'enable' => '1', 'value' => '"-A -T4 -p 21,22,111,135,139,445,35879"',
      'script' => 'cnm-nmap',
   );


//cnm-sslcerts
//OBTIENE LA INFORMACION DEL CERTIFICADO SSL
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_tcp_sslcerts', 'hparam' => '30000010', 'type' => 'latency', 'enable' => '1', 'value' => '',
      'script' => 'cnm-sslcerts',
   );
   $CFG_APP_PARAM[]=array(
      'aname' => 'app_tcp_sslcerts', 'hparam' => '30000011', 'type' => 'latency', 'enable' => '1', 'value' => '443',
      'script' => 'cnm-sslcerts',
   );


?>
