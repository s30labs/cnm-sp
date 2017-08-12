<?php
//---------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------
// tip_class=0 => De usuario tip_class=1 => De sistema (no se edita ni se borra)
//---------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------
//	Aplicacion
// El id_ref coincide con el aname de la aplicacion
//---------------------------------------------------------------------------------------------------------

      $TIPS[]=array(
         'id_ref' => 'app_icmp_ping10',          'tip_type' => 'app',
         'url' => '',      'date' => '',     'tip_class' => 1,
         'name' => 'Descripcion',
         'descr' => '<strong>Ejecuta un ping de 10 paquetes de 64 bytes</strong><br>'
      );
      $TIPS[]=array(
         'id_ref' => 'app_icmp_ping1024',          'tip_type' => 'app',
         'url' => '',      'date' => '',     'tip_class' => 1,
         'name' => 'Descripcion',
         'descr' => '<strong>Ejecuta un ping de 10 paquetes de 1024 bytes</strong><br>'
      );
      $TIPS[]=array(
         'id_ref' => 'app_tcp_traceroute',          'tip_type' => 'app',
         'url' => '',      'date' => '',     'tip_class' => 1,
         'name' => 'Descripcion',
         'descr' => '<strong>Muestra el numero de saltos hasta un destino</strong><br>'
      );
      $TIPS[]=array(
         'id_ref' => 'app_tcp_monitor',          'tip_type' => 'app',
         'url' => '',      'date' => '',     'tip_class' => 1,
         'name' => 'Descripcion',
         'descr' => '<strong>Establece una conexion TCP</strong><br>'
      );
      $TIPS[]=array(
         'id_ref' => 'app_smtp_monitor',          'tip_type' => 'app',
         'url' => '',      'date' => '',     'tip_class' => 1,
         'name' => 'Descripcion',
         'descr' => '<strong>Establece una conexion TCP por el puerto 25</strong><br>'
      );
      $TIPS[]=array(
         'id_ref' => 'app_tcp_scanports',          'tip_type' => 'app',
         'url' => '',      'date' => '',     'tip_class' => 1,
         'name' => 'Descripcion',
         'descr' => '<strong>Hace un escaneo de los primeros 10000 puertos TCP</strong><br>'
      );
      $TIPS[]=array(
         'id_ref' => 'app_tcp_scanso',          'tip_type' => 'app',
         'url' => '',      'date' => '',     'tip_class' => 1,
         'name' => 'Descripcion',
         'descr' => '<strong>Hace un escaneo de puertos con el objetivo de detectar el sistema operativo</strong><br>'
      );

/*
      $TIPS[]=array(
         'id_ref' => '',          'tip_type' => 'app',
         'url' => '',      'date' => '',     'tip_class' => 1,
         'name' => 'Descripcion',
         'descr' => '<strong></strong><br>'
      );

*/

?>
