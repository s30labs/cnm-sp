<?php
      $TIPS[]=array(
         'id_ref' => 'netscaler_cpu_total',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>resCpuUsage.0</strong> a partir de los siguientes atributos de la mib NS-ROOT-MIB:<br><br><strong>NS-ROOT-MIB::resCpuUsage.0 (GAUGE):</strong> "CPU utilization percentage."
',
      );


      $TIPS[]=array(
         'id_ref' => 'netscaler_mem_total',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>resMemUsage.0</strong> a partir de los siguientes atributos de la mib NS-ROOT-MIB:<br><br><strong>NS-ROOT-MIB::resMemUsage.0 (GAUGE):</strong> "Percentage of memory utilization on Citrix ADC."
',
      );


      $TIPS[]=array(
         'id_ref' => 'netscaler_cpu_usage',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>nsCPUusage</strong> a partir de los siguientes atributos de la mib NS-ROOT-MIB:<br><br><strong>NS-ROOT-MIB::nsCPUusage (GAUGE):</strong> "CPU utilization percentage."
',
      );


      $TIPS[]=array(
         'id_ref' => 'netscaler_disk_usage',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>sysHealthDiskPerusage</strong> a partir de los siguientes atributos de la mib NS-ROOT-MIB:<br><br><strong>NS-ROOT-MIB::sysHealthDiskPerusage (GAUGE):</strong> "The Percentage of the disk space used."
',
      );


      $TIPS[]=array(
         'id_ref' => 'netscaler_vsvr_activity',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>vsvrTotalRequests|vsvrTotalResponses</strong> a partir de los siguientes atributos de la mib NS-ROOT-MIB:<br><br><strong>NS-ROOT-MIB::vsvrTotalRequests (COUNTER):</strong> "Total number of requests received on this service or virtual server. (This applies to HTTP/SSL services and servers.)"
<strong>NS-ROOT-MIB::vsvrTotalResponses (COUNTER):</strong> "Number of responses received on this service or virtual server. (This applies to HTTP/SSL services and servers.)"
',
      );


      $TIPS[]=array(
         'id_ref' => 'netscaler_vsvr_traffic',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>vsvrTotalRequestBytes|vsvrTotalResponseBytes</strong> a partir de los siguientes atributos de la mib NS-ROOT-MIB:<br><br><strong>NS-ROOT-MIB::vsvrTotalRequestBytes (COUNTER):</strong> "Total number of request bytes received on this service or virtual server."
<strong>NS-ROOT-MIB::vsvrTotalResponseBytes (COUNTER):</strong> "Number of response bytes received by this service or virtual server."
',
      );


      $TIPS[]=array(
         'id_ref' => 'netscaler_vsvr_pkts',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>vsvrTotalPktsSent|vsvrTotalPktsRecvd</strong> a partir de los siguientes atributos de la mib NS-ROOT-MIB:<br><br><strong>NS-ROOT-MIB::vsvrTotalPktsSent (COUNTER):</strong> "Total number of packets sent."
<strong>NS-ROOT-MIB::vsvrTotalPktsRecvd (COUNTER):</strong> "Total number of packets received by this service or virtual server."
',
      );


      $TIPS[]=array(
         'id_ref' => 'netscaler_vsvr_cli_tot',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>vsvrTotalClients</strong> a partir de los siguientes atributos de la mib NS-ROOT-MIB:<br><br><strong>NS-ROOT-MIB::vsvrTotalClients (COUNTER):</strong> "Total number of established client connections."
',
      );


      $TIPS[]=array(
         'id_ref' => 'netscaler_vsvr_open_rate',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>vsvrClientConnOpenRate</strong> a partir de los siguientes atributos de la mib NS-ROOT-MIB:<br><br><strong>NS-ROOT-MIB::vsvrClientConnOpenRate (GAUGE):</strong> "Rate at which connections are opened for this virtual server per second."
',
      );


      $TIPS[]=array(
         'id_ref' => 'netscaler_vsvr_surge_cnt',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>vsvrSurgeCount</strong> a partir de los siguientes atributos de la mib NS-ROOT-MIB:<br><br><strong>NS-ROOT-MIB::vsvrSurgeCount (GAUGE):</strong> "Number of requests in the surge queue."
',
      );


      $TIPS[]=array(
         'id_ref' => 'netscaler_vsvr_health',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>vsvrHealth</strong> a partir de los siguientes atributos de la mib NS-ROOT-MIB:<br><br><strong>NS-ROOT-MIB::vsvrHealth (GAUGE):</strong> "The percentage of UP services bound to this vserver."
',
      );


      $TIPS[]=array(
         'id_ref' => 'netscaler_health_cnt',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>vsvrHealth</strong> a partir de los siguientes atributos de la mib NS-ROOT-MIB:<br><br><strong>NS-ROOT-MIB::sysHealthCounterValue (GAUGE):</strong> "The health counters value. The units are mv, RPM and degrees Celsius for voltage, fan and temperatures respectively."
',
      );


      $TIPS[]=array(
         'id_ref' => 'netscaler_vsvr_status',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>up(7)|down(1)|unknown(2)|busy(3)|outOfService(4)|transitionToOutOfService(5)|transitionToOutOfServiceDown(8)</strong> a partir de los siguientes atributos de la mib NS-ROOT-MIB:<br><br><strong>NS-ROOT-MIB::vsvrState (GAUGE):</strong> "Current state of the server. There are seven possible values: UP(7), DOWN(1), UNKNOWN(2), BUSY(3), OFS(Out of Service)(4), TROFS(Transition Out of Service)(5), TROFS_DOWN(Down When going Out of Service)(8)"
',
      );


?>
