<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_icmp_dual.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este script monitoriza la conectividad de dos direcciones IP diferentes. En función de los resultados obtenidos devuelve un valor numérico.
La IP principal es la del dispositivo sobre el que se aplica el script. La IP secundaria se almacena en un campo de usuario de dispositivo que tiene que definir el administrador. El nombre de dicho campo es el segundo parámetro del script, como vemos a continuación:

cnm@cnm-devel:/opt/cnm-sp/icmp-dual# xagent/base/linux_metric_icmp_dual.pl
mon_icmp_dual 1.0

Monitoriza si hay conectividad con dos direcciones IP diferentes.
Devuelve un valor numerico que representa un estado en funcion los resultados.
La tabla de decision es:

IP1   IP2   VALOR DEVUELTO
0     0     3  (No se accede ninguna de las dos)
0     1     2  (Se accede a IP2, No se accede a IP1)
1     0     1  (Se accede a IP1, No se accede a IP2)
1     1     0  (Se accede a las dos)
            4  (Desconocido)

linux_metric_icmp_dual.pl -h : Ayuda
linux_metric_icmp_dual.pl -n host -s Campo_de_Usuario_con_IP2 : Chequea servicio ICMP

-n   IP (IP1)
-s   Nombre del campo de usuario que contiene (IP2)
-h   Help
',
      );

?>
