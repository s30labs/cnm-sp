<?php
      $TIPS[]=array(
         'id_ref' => 'h3c_cpu_usage',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>Uso de CPU (%)</strong> a partir de los siguientes atributos de la mib HH3C-LSW-DEV-ADM-MIB:<br><br><strong>HH3C-LSW-DEV-ADM-MIB::hh3cLswSysCpuRatio.0 (GAUGE):</strong> "CPU usage of the system in accuracy of 1%, and the range of value is 1
          to 100."
',
      );


      $TIPS[]=array(
         'id_ref' => 'h3c_mem_usage',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>Uso de Memoria (%)</strong> a partir de los siguientes atributos de la mib HH3C-LSW-DEV-ADM-MIB:<br><br><strong>HH3C-LSW-DEV-ADM-MIB::hh3cLswSysMemoryRatio.0 (GAUGE):</strong> "The percentage of system memory in use.
         Note that the system memory means the memory can be used by the software
         platform.
 
                                 hh3cLswSysMemoryUsed
         hh3cLswSysMemoryRatio = --------------------
                                  hh3cLswSysMemory
 
         For the distributed device, it represents the memory used ratio on the
         master slot."
',
      );


      $TIPS[]=array(
         'id_ref' => 'h3c_fan_status',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>active|deactive|not installed|unsupported</strong> a partir de los siguientes atributos de la mib HH3C-LswDEVM-MIB:<br><br><strong>HH3C-LswDEVM-MIB::hh3cDevMFanStatus (GAUGE):</strong> " Fan status: active (1), deactive (2) not installed (3) and unsupported (4)"
',
      );


      $TIPS[]=array(
         'id_ref' => 'h3c_power_status',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>active|deactive|not installed|unsupported</strong> a partir de los siguientes atributos de la mib HH3C-LswDEVM-MIB:<br><br><strong>HH3C-LswDEVM-MIB::hh3cDevMPowerStatus (GAUGE):</strong> " Power status: active (1), deactive (2) not installed (3) and unsupported    "
',
      );


      $TIPS[]=array(
         'id_ref' => 'h3c_cpu_usage_slot',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>Uso de CPU (%)</strong> a partir de los siguientes atributos de la mib HH3C-LSW-DEV-ADM-MIB:<br><br><strong>HH3C-LSW-DEV-ADM-MIB::hh3cLswSlotCpuRatio (GAUGE):</strong> "CPU usage of the slot in accuracy of 1%, and the range of value is 1 to
          100."
',
      );


      $TIPS[]=array(
         'id_ref' => 'h3c_flash_space',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>Free bytes|Total bytes</strong> a partir de los siguientes atributos de la mib HH3C-FLASH-MAN-MIB:<br><br><strong>HH3C-FLASH-MAN-MIB::hh3cFlhPartSpaceFree (GAUGE):</strong> "The flash partitions free space."
<strong>HH3C-FLASH-MAN-MIB::hh3cFlhPartSpace (GAUGE):</strong> "
                 The total space of the flash partition.
                 The following should be satisfied:
                 hh3cFlhPartSpace = n*hh3cFlhMinPartitionSize
                 "
',
      );


      $TIPS[]=array(
         'id_ref' => 'h3c_flash_spacep',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>Free space (%)</strong> a partir de los siguientes atributos de la mib HH3C-FLASH-MAN-MIB:<br><br><strong>HH3C-FLASH-MAN-MIB::hh3cFlhPartSpaceFree (GAUGE):</strong> "The flash partitions free space."
<strong>HH3C-FLASH-MAN-MIB::hh3cFlhPartSpace (GAUGE):</strong> "
                 The total space of the flash partition.
                 The following should be satisfied:
                 hh3cFlhPartSpace = n*hh3cFlhMinPartitionSize
                 "
',
      );


?>
