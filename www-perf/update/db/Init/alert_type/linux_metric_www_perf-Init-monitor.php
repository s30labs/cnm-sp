<?php

      $ALERT_TYPE[]=array(
            'monitor' => 's_xagt_004600-bf8b6871',  'cause'=>'TIEMPO DE CARGA EXCESIVO', 'hide'=>'0',
            'expr'=>'v1>5', 'params' => '',    'severity' => '2',
            'mname'=>'xagt_004600',   'type'=>'xagent',   'subtype'=>'xagt_004600',
            'wsize' => '0',   'class' => 'proxy-linux'
      );


      $ALERT_TYPE[]=array(
            'monitor' => 's_xagt_004601-e32744b5',  'cause'=>'ERROR DE SERVIDOR (5xx)', 'hide'=>'0',
            'expr'=>'v3>1', 'params' => '',    'severity' => '1',
            'mname'=>'xagt_004601',   'type'=>'xagent',   'subtype'=>'xagt_004601',
            'wsize' => '0',   'class' => 'proxy-linux'
      );

?>
