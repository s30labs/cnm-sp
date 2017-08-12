<?php
      $TIPS[]=array(
         'id_ref' => 'apc_bat_status',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>batteryNormal(2)|unknown(1)|batteryInFaultCondition(4)|batteryLow(3)</strong> a partir de los siguientes atributos de la mib PowerNet-MIB:<br><br><strong>PowerNet-MIB::upsBasicBatteryStatus.0 (GAUGE):</strong> "The status of the UPS batteries. A batteryLow(3) value 
        indicates the UPS will be unable to sustain the current 
        load, and its services will be lost if power is not restored.
        The amount of run time in reserve at the time of low battery 
        can be configured by the upsAdvConfigLowBatteryRunTime.
        A batteryInFaultCondition(4)value indicates that a battery 
        installed has an internal error condition."
',
      );


      $TIPS[]=array(
         'id_ref' => 'apc_temperature',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>Temperatura (Celsius)</strong> a partir de los siguientes atributos de la mib PowerNet-MIB:<br><br><strong>PowerNet-MIB::upsAdvBatteryTemperature.0 (GAUGE):</strong> "The current internal UPS temperature expressed in 
        Celsius."
',
      );


      $TIPS[]=array(
         'id_ref' => 'apc_voltage',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>Voltaje (Voltios)</strong> a partir de los siguientes atributos de la mib PowerNet-MIB:<br><br><strong>PowerNet-MIB::upsAdvBatteryActualVoltage.0 (GAUGE):</strong> "The actual battery bus voltage in Volts."
',
      );


      $TIPS[]=array(
         'id_ref' => 'apc_load',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>Carga de la UPS (%)</strong> a partir de los siguientes atributos de la mib PowerNet-MIB:<br><br><strong>PowerNet-MIB::upsAdvOutputLoad.0 (GAUGE):</strong> "The current UPS load expressed in percent 
        of rated capacity."
',
      );


      $TIPS[]=array(
         'id_ref' => 'apc_comm_status',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>ok(1)|noComm(2)</strong> a partir de los siguientes atributos de la mib PowerNet-MIB:<br><br><strong>PowerNet-MIB::upsCommStatus.0 (GAUGE):</strong> "The status of agents communication with UPS. "
',
      );


      $TIPS[]=array(
         'id_ref' => 'apc_bat_time',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>Tiempo restante operativo (min.)</strong> a partir de los siguientes atributos de la mib PowerNet-MIB:<br><br><strong>PowerNet-MIB::upsAdvBatteryRunTimeRemaining.0 (GAUGE):</strong> "The UPS battery run time remaining before battery 
        exhaustion."
',
      );


?>
