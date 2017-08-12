<?php
      $TIPS[]=array(
         'id_ref' => 'app_linux_net_config_to_syslog',  'tip_type' => 'app', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Ejecuta por SSH los siguientes comandos: netstat -rn y cat /etc/resolv.conf. El resultado lo envia a CNM por syslog.',
      );

      $TIPS[]=array(
         'id_ref' => 'app_ccm_diag_to_syslog',  'tip_type' => 'app', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Ejecuta por SSH el comando "utils diagnose test" en un Call Manager de Cisco. El resultado lo envia a CNM por syslog.',
      );

?>
