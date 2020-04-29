<?php
      $TIPS[]=array(
         'id_ref' => 'app_vmware_vminfo_table',  'tip_type' => 'app', 'url' => '',
         'date' => 1587750353,     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => '<strong>Muestra las maquinas virtuales configuradas en el sistema</strong><br>Utiliza la tabla SNMP VMWARE-VMINFO-MIB::vmwVmTable (Enterprise=06876)<br><br><strong>VMWARE-VMINFO-MIB::vmwVmDisplayName (GAUGE):</strong><br>"Name by which this vm is displayed. It is not guaranteed to be unique.
                  MOB: https://esx.example.com/mob/?moid=vmwVmIdx&doPath=summary%2eguest"
<strong>VMWARE-VMINFO-MIB::vmwVmConfigFile (GAUGE):</strong><br>"Path to the configuration file for this vm expressed as a fully
                  qualified path name in POSIX or DOS extended format
                  VM Config file File name:
                  MOB: https://esx.example.com/mob/?moid=vmwVmIdx&doPath=config%2efiles
                  VM Datastore containing the filename:
                  MOB: https://esx.example.com/mob/?moid=vmwVmIdx&doPath=config%2edatastoreUrl"
<strong>VMWARE-VMINFO-MIB::vmwVmGuestOS (GAUGE):</strong><br>"Operating system running on this vm. This value corresponds to the
                  value specified when creating the VM and unless set correctly may differ
                  from the actual OS running. Will return one of the values if set in order:
                    Vim.Vm.GuestInfo.guestFullName
                    Vim.Vm.GuestInfo.guestId
                    Vim.Vm.GuestInfo.guestFamily
                  MOB: https://esx.example.com/mob/?moid=vmwVmIdx&doPath=guest 
                       where moid = vmwVmIdx.
                  If VMware Tools is not running, value will be of form E: error message"
<strong>VMWARE-VMINFO-MIB::vmwVmMemSize (GAUGE):</strong><br>"Memory configured for this virtual machine. 
                  Memory > MAX Integer32 is reported as max integer32.
                 VIM Property: memoryMB
                 MOB: https://esx.example.com/mob/?moid=vmwVmIdx&doPath=config%2ehardware"
<strong>VMWARE-VMINFO-MIB::vmwVmState (GAUGE):</strong><br>"Power state of the virtual machine.
                 VIM Property: powerState
                 MOB: https://esx.example.com/mob/?moid=vmwVmIdx&doPath=summary%2eruntime"
<strong>VMWARE-VMINFO-MIB::vmwVmGuestState (GAUGE):</strong><br>"Operation mode of guest operating system. Values include:
                   running  - Guest is running normally.
                   shuttingdown - Guest has a pending shutdown command.
                   resetting - Guest has a pending reset command.
                   standby - Guest has a pending standby command.
                   notrunning - Guest is not running.
                   unknown - Guest information is not available.
                 VIM Property: guestState
                 MOB: https://esx.example.com/mob/?moid=vmwVmIdx&doPath=guest"
<strong>VMWARE-VMINFO-MIB::vmwVmCpus (GAUGE):</strong><br>"Number of virtual CPUs assigned to this virtual machine.
                 VIM Property: numCPU 
                 MOB: https://esx.example.com/mob/?moid=vmwVmIdx&doPath=config%2ehardware"
<strong>VMWARE-VMINFO-MIB::vmwVmUUID (GAUGE):</strong><br>"A unique identifier for this VM. Must be unique across a set of ESX systems
 	         managed by an instance of vSphere Center. 
                  Example value: 564d95d4-bff7-31fd-f20f-db2d808a8b32
                  VIM Property: uuid 
                  MOB: https://esx.example.com/mob/?moid=vmwVmIdx&doPath=config"
',
      );


      $TIPS[]=array(
         'id_ref' => 'app_vmware_get_info',  'tip_type' => 'app', 'url' => '',
         'date' => 1587750353,     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => '<strong>Muestra informacion basica sobre el equipo</strong><br>Utiliza atributos de la mib VMWARE-SYSTEM-MIB:<br><br><strong>VMWARE-SYSTEM-MIB::vmwProdName (GAUGE):</strong>&nbsp;"This products name.
          VIM Property: AboutInfo.name
          https://esx.example.com/mob/?moid=ServiceInstance&doPath=content%2eabout"
<br><strong>VMWARE-SYSTEM-MIB::vmwProdVersion (GAUGE):</strong>&nbsp;"The products version release identifier. Format is Major.Minor.Update
          VIM Property: AboutInfo.version
          https://esx.example.com/mob/?moid=ServiceInstance&doPath=content%2eabout"
<br><strong>VMWARE-SYSTEM-MIB::vmwProdOID (GAUGE):</strong>&nbsp;<br><strong>VMWARE-SYSTEM-MIB::vmwProdBuild (GAUGE):</strong>&nbsp;"This identifier represents the most specific identifier.
          VIM Property: AboutInfo.build
          https://esx.example.com/mob/?moid=ServiceInstance&doPath=content%2eabout"
<br>',
      );


?>
