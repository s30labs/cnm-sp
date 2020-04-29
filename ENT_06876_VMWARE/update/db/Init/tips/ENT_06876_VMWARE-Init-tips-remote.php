<?php
      $TIPS[]=array(
         'id_ref' => 'VMWARE-TRAPS-MIB::vmPoweredOn',  'tip_type' => 'remote', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'CNM-Info', 'hiid' => '842b1bd2b7',
         'descr' => '"This trap is sent when a virtual machine is powered ON from a suspended 
        or a powered off state."
v1: <strong>vmID</strong><br>"This holds the same value as vmwVmVMID of the affected vm generating the trap.
          to allow polling of the affected vm in vmwVmTable."
<br>Integer32
   <br>v2: <strong>vmConfigFile</strong><br>"This is the path to the config file of the affected vm generating the trap 
          and is same as vmwVmTable vmwVmConfigFile. It is expressed as POSIX pathname."
<br>OCTET STRING (0..255) 
   <br>',
      );


      $TIPS[]=array(
         'id_ref' => 'VMWARE-TRAPS-MIB::vmPoweredOff',  'tip_type' => 'remote', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'CNM-Info', 'hiid' => '842b1bd2b7',
         'descr' => '"This trap is sent when a virtual machine is powered OFF."
v1: <strong>vmID</strong><br>"This holds the same value as vmwVmVMID of the affected vm generating the trap.
          to allow polling of the affected vm in vmwVmTable."
<br>Integer32
   <br>v2: <strong>vmConfigFile</strong><br>"This is the path to the config file of the affected vm generating the trap 
          and is same as vmwVmTable vmwVmConfigFile. It is expressed as POSIX pathname."
<br>OCTET STRING (0..255) 
   <br>',
      );


      $TIPS[]=array(
         'id_ref' => 'VMWARE-TRAPS-MIB::vmHBLost',  'tip_type' => 'remote', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'CNM-Info', 'hiid' => '842b1bd2b7',
         'descr' => '"This trap is sent when a virtual machine detects a loss in guest heartbeat."
v1: <strong>vmID</strong><br>"This holds the same value as vmwVmVMID of the affected vm generating the trap.
          to allow polling of the affected vm in vmwVmTable."
<br>Integer32
   <br>v2: <strong>vmConfigFile</strong><br>"This is the path to the config file of the affected vm generating the trap 
          and is same as vmwVmTable vmwVmConfigFile. It is expressed as POSIX pathname."
<br>OCTET STRING (0..255) 
   <br>',
      );


      $TIPS[]=array(
         'id_ref' => 'VMWARE-TRAPS-MIB::vmHBDetected',  'tip_type' => 'remote', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'CNM-Info', 'hiid' => '842b1bd2b7',
         'descr' => '"This trap is sent when a virtual machine detects or regains the guest heartbeat."
v1: <strong>vmID</strong><br>"This holds the same value as vmwVmVMID of the affected vm generating the trap.
          to allow polling of the affected vm in vmwVmTable."
<br>Integer32
   <br>v2: <strong>vmConfigFile</strong><br>"This is the path to the config file of the affected vm generating the trap 
          and is same as vmwVmTable vmwVmConfigFile. It is expressed as POSIX pathname."
<br>OCTET STRING (0..255) 
   <br>',
      );


      $TIPS[]=array(
         'id_ref' => 'VMWARE-TRAPS-MIB::vmSuspended',  'tip_type' => 'remote', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'CNM-Info', 'hiid' => '842b1bd2b7',
         'descr' => '"This trap is sent when a virtual machine is suspended."
v1: <strong>vmID</strong><br>"This holds the same value as vmwVmVMID of the affected vm generating the trap.
          to allow polling of the affected vm in vmwVmTable."
<br>Integer32
   <br>v2: <strong>vmConfigFile</strong><br>"This is the path to the config file of the affected vm generating the trap 
          and is same as vmwVmTable vmwVmConfigFile. It is expressed as POSIX pathname."
<br>OCTET STRING (0..255) 
   <br>',
      );


?>
