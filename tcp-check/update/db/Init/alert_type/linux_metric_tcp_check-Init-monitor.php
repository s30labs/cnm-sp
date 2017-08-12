<?php

      $ALERT_TYPE[]=array(
            'monitor' => 's_xagt_004010-edf8e3ca',  'cause'=>'RESPUESTA LENTA EN PUERTO 80/TCP', 'hide'=>'0',
            'expr'=>'v1>1', 'params' => '',    'severity' => '2',
            'mname'=>'xagt_004010',   'type'=>'xagent',   'subtype'=>'xagt_004010',
            'wsize' => '0',   'class' => 'proxy-linux'
      );


      $ALERT_TYPE[]=array(
            'monitor' => 's_xagt_004011-097d9815',  'cause'=>'ERROR EN PUERTO 80/TCP', 'hide'=>'0',
            'expr'=>'v3=1', 'params' => '',    'severity' => '1',
            'mname'=>'xagt_004011',   'type'=>'xagent',   'subtype'=>'xagt_004011',
            'wsize' => '0',   'class' => 'proxy-linux'
      );


      $ALERT_TYPE[]=array(
            'monitor' => 's_xagt_004012-edf8e3ca',  'cause'=>'RESPUESTA LENTA EN PUERTO 443/TCP', 'hide'=>'0',
            'expr'=>'v1>1', 'params' => '',    'severity' => '2',
            'mname'=>'xagt_004012',   'type'=>'xagent',   'subtype'=>'xagt_004012',
            'wsize' => '0',   'class' => 'proxy-linux'
      );


      $ALERT_TYPE[]=array(
            'monitor' => 's_xagt_004013-edf8e3ca',  'cause'=>'ERROR EN PUERTO 443/TCP', 'hide'=>'0',
            'expr'=>'v3=1', 'params' => '',    'severity' => '1',
            'mname'=>'xagt_004013',   'type'=>'xagent',   'subtype'=>'xagt_004013',
            'wsize' => '0',   'class' => 'proxy-linux'
      );

?>
