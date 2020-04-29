<?php
      $TIPS[]=array(
         'id_ref' => 'vmware_cpu_util',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>cpuUtil</strong> a partir de los siguientes atributos de la mib VMWARE-RESOURCES-MIB:<br><br><strong>VMWARE-RESOURCES-MIB::cpuUtil (GAUGE):</strong> ',
      );


      $TIPS[]=array(
         'id_ref' => 'vmware_mem_util',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>memUtil|memConfigured</strong> a partir de los siguientes atributos de la mib VMWARE-RESOURCES-MIB:<br><br><strong>VMWARE-RESOURCES-MIB::memUtil (GAUGE):</strong> <strong>VMWARE-RESOURCES-MIB::memConfigured (GAUGE):</strong> ',
      );


      $TIPS[]=array(
         'id_ref' => 'vmware_disk_util_kb',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>kbRead|kbWritten</strong> a partir de los siguientes atributos de la mib VMWARE-RESOURCES-MIB:<br><br><strong>VMWARE-RESOURCES-MIB::kbRead (GAUGE):</strong> <strong>VMWARE-RESOURCES-MIB::kbWritten (GAUGE):</strong> ',
      );


      $TIPS[]=array(
         'id_ref' => 'vmware_net_util_kb',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>kbTx|kbRx</strong> a partir de los siguientes atributos de la mib VMWARE-RESOURCES-MIB:<br><br><strong>VMWARE-RESOURCES-MIB::kbTx (GAUGE):</strong> <strong>VMWARE-RESOURCES-MIB::kbRx (GAUGE):</strong> ',
      );


      $TIPS[]=array(
         'id_ref' => 'vmware_mem_cfg',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>vmwVmMemSize</strong> a partir de los siguientes atributos de la mib VMWARE-VMINFO-MIB:<br><br><strong>VMWARE-VMINFO-MIB::vmwVmMemSize (GAUGE):</strong> "Memory configured for this virtual machine. 
                  Memory > MAX Integer32 is reported as max integer32.
                 VIM Property: memoryMB
                 MOB: https://esx.example.com/mob/?moid=vmwVmIdx&doPath=config%2ehardware"
',
      );


      $TIPS[]=array(
         'id_ref' => 'vmware_vm_status',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>running|notRunning</strong> a partir de los siguientes atributos de la mib VMWARE-VMINFO-MIB:<br><br><strong>VMWARE-VMINFO-MIB::vmwVmGuestState (GAUGE):</strong> "Operation mode of guest operating system. Values include:
                   running  - Guest is running normally.
                   shuttingdown - Guest has a pending shutdown command.
                   resetting - Guest has a pending reset command.
                   standby - Guest has a pending standby command.
                   notrunning - Guest is not running.
                   unknown - Guest information is not available.
                 VIM Property: guestState
                 MOB: https://esx.example.com/mob/?moid=vmwVmIdx&doPath=guest"
',
      );


      $TIPS[]=array(
         'id_ref' => 'vmware_vm_glob_status',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>running|notRunning</strong> a partir de los siguientes atributos de la mib VMWARE-VMINFO-MIB:<br><br><strong>VMWARE-VMINFO-MIB::vmwVmGuestState (GAUGE):</strong> "Operation mode of guest operating system. Values include:
                   running  - Guest is running normally.
                   shuttingdown - Guest has a pending shutdown command.
                   resetting - Guest has a pending reset command.
                   standby - Guest has a pending standby command.
                   notrunning - Guest is not running.
                   unknown - Guest information is not available.
                 VIM Property: guestState
                 MOB: https://esx.example.com/mob/?moid=vmwVmIdx&doPath=guest"
',
      );


      $TIPS[]=array(
         'id_ref' => 'vmware_vm_glob_mem',	'tip_type' => 'cfg',	'url' => '',
         'date' => '',     'tip_class' => 1,	'name' => 'Descripcion',
         'descr' => 'Mide: <strong>running|notRunning</strong> a partir de los siguientes atributos de la mib VMWARE-VMINFO-MIB:<br><br><strong>VMWARE-VMINFO-MIB::vmwVmGuestState (GAUGE):</strong> "Operation mode of guest operating system. Values include:
                   running  - Guest is running normally.
                   shuttingdown - Guest has a pending shutdown command.
                   resetting - Guest has a pending reset command.
                   standby - Guest has a pending standby command.
                   notrunning - Guest is not running.
                   unknown - Guest information is not available.
                 VIM Property: guestState
                 MOB: https://esx.example.com/mob/?moid=vmwVmIdx&doPath=guest"
<strong>VMWARE-VMINFO-MIB::vmwVmMemSize (GAUGE):</strong> "Memory configured for this virtual machine. 
                  Memory > MAX Integer32 is reported as max integer32.
                 VIM Property: memoryMB
                 MOB: https://esx.example.com/mob/?moid=vmwVmIdx&doPath=config%2ehardware"
',
      );


?>
