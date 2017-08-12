<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_apache_mod_status.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este script permite obtener los datos de rendimiento de un servidor Apache proporcionados por el modulo mod_status.<br>Para que funcione correctamente, debe estar habilitado el modulo mod_status en el servidor de Apache (http://httpd.apache.org/docs/2.2/mod/mod_status.html).<br>Para configurar el módulo en Apache 2.x se deben seguir las siguientes instrucciones:<br>Confirmar que mod_info está corriendo:<br>a2enmod info<br>Incluir en el fichero de configuraión:<br><Location /server-status>
    SetHandler server-status
    Order deny,allow
    Deny from all
    Allow from .your_domain.com
</Location><br>Si se habilita el modo extendido mediante la directiva:<br>ExtendedStatus On<br>se obtienen más datos.',
      );

?>
