<?php
      $TIPS[]=array(
         'id_ref' => 'cnm_app_api_device.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este escript permite modificar campos de los dispositivos definidos en CNM mediante el API. Sus parámetros de ejecución son:<b
cnm@cnm:/opt/cnm/xagent/base# ./cnm_app_api_device.pl -h
cnm_app_api_device.pl 1.0

cnm_app_api_device.pl [-d] [-cid default] -ip=1.1.1.1 -status 0 -domain nuevo.com
cnm_app_api_device.pl [-d] [-cid default] -id=1 -status 0 -domain nuevo.com
cnm_app_api_device.pl -h  : Ayuda

id:          Id del dispositivo cuyo campo/campos se van a actualizar.
ip:          IP del dispositivo cuyo campo/campos se van a actualizar.
name:        Nombre del dispositivo
domain:      Dominio del dispositivo
type:        Tipo del dispositivo
geo:         Coordenadas de Geolocalizacion del dispositivo
critic:      Criticidad del dispositivo
correlated:  ID del dispositivo del que depende
status:      Estado del dispositivo (0:activo | 1:inactivo | 2:mantenimiento)
profile:     Perfil al que pertenece el dispositivo
user:        Permite especificar valores para campos de usuario. P. ej: Precio=1000,Proveedor=s30labs
',
      );

?>
