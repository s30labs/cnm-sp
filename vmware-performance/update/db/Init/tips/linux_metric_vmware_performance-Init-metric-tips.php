<?php
      $TIPS[]=array(
         'id_ref' => 'xagt_004520',  'tip_type' => 'agent', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Métrica que monitoriza el porcentaje de uso de CPU en un host ESX/ESXi a partir del API de vSphere. Es una relación entre la CPU usada y la disponible. (CPU disponible = Num. CPUs x frec. de reloj).
El 100% representa todas las CPUs del Host. Si por ejemplo un Host con cuatro CPUs físicas tiene arrancada una máquina virtual con dos CPUs y este valor está al 50% significa que el host está usando las dos CPUs totalmente.',
      );

      $TIPS[]=array(
         'id_ref' => 'xagt_004521',  'tip_type' => 'agent', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Métrica que monitoriza el uso detallado de la memoria de un host ESX/ESXi a partir del API de vSphere.
Se obtienen los siguientes valores:
1. Consumida: Cantidad de memoria consumida por una máquina virtual. En el caso del Host incluye la memoria del servicio de consola, de los servicios de vSphere junto con las de todas las maquinas virtuales en ejecución.
2. Overhead: Es la memoria asignada a una máquina virtual por encima de la que tiene reservada. En el caso del host incluye la memoria de todas las máquinas virtuales junto con los servicios de vSphere.
3. Shared: Memoria compartida con otras máquinas virtuales. En el caso del Host se refiere a todas las máquinas virtuales arrancadas.
4. Swap: Memoria usada para swap. En el caso del Host se refiere a todas las máquinas virtuales arrancadas.
5. Balloon: Memoria asignada por el driver de control de la memoria virtual (vmmemctl), que se instala con las herramientas
VMWare Tools y controla el ballooning.
',
      );

      $TIPS[]=array(
         'id_ref' => 'xagt_004522',  'tip_type' => 'agent', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Métrica que monitoriza los umbrales que representan el porcentaje de memoria libre en el host ESX/ESXi a partir del API de vSphere. 
Este valor determina el comportamiento en cuanto a "swapping" o "ballooning" del host.
0 = High Indica que el umbral de memoria libre es >= 6% de la memoria de la maquina menos la del servicio de consola.
1 = Soft Indica que el umbral de memoria libre es >= 4%
2 = Hard Indica que el umbral de memoria libre es >= 2%
3 = Low Indica que el umbral de memoria libre es >= 1%
High y Soft indican que hay más swapping que ballooning.
Hard y Low indica que hay más ballooning que swapping.
',
      );

      $TIPS[]=array(
         'id_ref' => 'xagt_004530',  'tip_type' => 'agent', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Métrica que monitoriza el uso de los datastores de un host VMWARE (ESX/ESXi) a partir de los datos proporcionados por el API de vSphere.',
      );

      $TIPS[]=array(
         'id_ref' => 'xagt_004531',  'tip_type' => 'agent', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Métrica que monitoriza errores de IO en los accesos a los disco de un host VMWARE (ESX/ESXi) a partir de los datos proporcionados por el API de vSphere.',
      );

      $TIPS[]=array(
         'id_ref' => 'xagt_004532',  'tip_type' => 'agent', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Métrica que representa el tiempo de acceso al disco de un host VMWARE (ESX/ESXi) en milisegundos. Se obtiene a partir de los datos proporcionados por el API de vSphere.',
      );

      $TIPS[]=array(
         'id_ref' => 'xagt_004533',  'tip_type' => 'agent', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Métrica que representa el tiempo consumido en la cola del VMKernel durante el acceso a un disco de un host VMWARE (ESX/ESXi) en milisegundos. Se obtiene a partir de los datos proporcionados por el API de vSphere.',
      );

      $TIPS[]=array(
         'id_ref' => 'xagt_004534',  'tip_type' => 'agent', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Métrica que representa el tiempo consumido por el VMKernel al procesar los comandos SCSI en el acceso a un disco de un host VMWARE (ESX/ESXi) en milisegundos. Se obtiene a partir de los datos proporcionados por el API de vSphere.',
      );

      $TIPS[]=array(
         'id_ref' => 'xagt_004535',  'tip_type' => 'agent', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Métrica que representa el tiempo consumido en el dispositivo fisico (LUN) al ejecutar comandos SCSI en el acceso a un disco de un host VMWARE (ESX/ESXi) en milisegundos. Se obtiene a partir de los datos proporcionados por el API de vSphere.',
      );

      $TIPS[]=array(
         'id_ref' => 'xagt_004536',  'tip_type' => 'agent', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Mide en un host VMWARE (ESX/ESXi) el número de paquetes transmitidos y recibidos junto con los de tipo broadcast y multicast. Se obtiene a partir de los datos proporcionados por el API de vSphere.',
      );

      $TIPS[]=array(
         'id_ref' => 'xagt_004537',  'tip_type' => 'agent', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Mide en un host VMWARE (ESX/ESXi) el número de paquetes descartados y con errores. Se obtiene a partir de los datos proporcionados por el API de vSphere.',
      );

?>
