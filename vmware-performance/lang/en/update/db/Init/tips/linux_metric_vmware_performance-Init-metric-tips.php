<?php
	$TIPS[]=array(
		'id_ref' => 'xagt_004520',
		'tip_type' => 'agent',
		'name' => 'Descripcion',
		'descr' => 'Metric that represents the CPU usage percentage in a ESX/ESXi host. Provided by the vSphere API. 
Actively used CPU of the host, as a percentage of the total available CPU. Active CPU is approximately equal to the ratio of the used CPU to the available CPU. 
available CPU = # of physical CPUs x clock rate 
100% represents all CPUs on the host. For example, if a four-CPU host is running a virtual machine with two CPUs, and the usage is 50%, the host is using two CPUs completely.',
	);

	$TIPS[]=array(
		'id_ref' => 'xagt_004521',
		'tip_type' => 'agent',
		'name' => 'Descripcion',
		'descr' => 'Métrica que monitoriza el uso detallado de la memoria de un host ESX/ESXi a partir del API de vSphere.
Se obtienen los siguientes valores:
1. Consumed: Amount of machine memory used on the host. Consumed memory includes Includes memory used by the Service Console, the VMkernel, vSphere services, plus the total consumed metrics for all running virtual machines. 
host consumed memory = total host memory - free host memory 
2. Overhead: Amount of machine memory allocated to a virtual machine beyond its reserved amount. Total of all overhead metrics for powered-on virtual machines, plus the overhead of running vSphere services on the host.
3. Shared: Amount of guest memory that is shared with other virtual machines, relative to a single virtual machine or to all powered-on virtual machines on a host. 
Sum of all shared metrics for all powered-on virtual machines, plus amount for vSphere services on the host. The host shared memory may be larger than the amount of machine memory if memory is overcommitted (the aggregate virtual machine configured memory is much greater than machine memory). The value of this statistic reflects how effective transparent page sharing and memory overcommitment are for saving machine memory. 
4. Swap: Amount of memory that is used by swap. Sum of memory swapped of all powered on VMs and vSphere services on the host.
5. Balloon: Amount of memory allocated by the virtual machine memory control driver (vmmemctl), which is installed with VMware Tools. It’s a VMware exclusive memory-management driver that controls ballooning.
The sum of all vmmemctl values for all powered-on virtual machines, plus vSphere services on the host. If the balloon target value is greater than the balloon value, the VMkernel inflates the balloon, causing more virtual machine memory to be reclaimed. If the balloon target value is less than the balloon value, the VMkernel deflates the balloon, which allows the virtual machine to consume additional memory if needed.',
	);

	$TIPS[]=array(
		'id_ref' => 'xagt_004522',
		'tip_type' => 'agent',
		'name' => 'Descripcion',
		'descr' => 'Provides one of four threshold levels representing the percentage of free memory on the host. The counter value determines swapping and ballooning behavior for memory reclamation. 
0   (high)  Free memory >= 6% of machine memory minus Service Console memory. 
1   (soft)  4% 
2   (hard)  2% 
3   (low)  1% 
0 (high) and 1 (soft):  Swapping is favored over ballooning.
2 (hard) and 3 (low):  Ballooning is favored over swapping.
',
	);

	$TIPS[]=array(
		'id_ref' => 'xagt_004530',
		'tip_type' => 'agent',
		'name' => 'Descripcion',
		'descr' => 'Provides the usage of an VMWARE (ESX/ESXi) datastore. Provided by the vSphere API.',
	);

	$TIPS[]=array(
		'id_ref' => 'xagt_004531',
		'tip_type' => 'agent',
		'name' => 'Descripcion',
		'descr' => 'Provides the IO disk errors of an VMWARE (ESX/ESXi) host. Provided by the vSphere API.',
	);

	$TIPS[]=array(
		'id_ref' => 'xagt_004532',
		'tip_type' => 'agent',
		'name' => 'Descripcion',
		'descr' => 'Provides the IO disk latency of an VMWARE (ESX/ESXi) host. Provided by the vSphere API.',
	);

	$TIPS[]=array(
		'id_ref' => 'xagt_004533',
		'tip_type' => 'agent',
		'name' => 'Descripcion',
		'descr' => 'Provides the VMKernel queue latency of an VMWARE (ESX/ESXi) host. Provided by the vSphere API.',
	);

	$TIPS[]=array(
		'id_ref' => 'xagt_004534',
		'tip_type' => 'agent',
		'name' => 'Descripcion',
		'descr' => 'Provides the VMKernel SCSI commands latency of an VMWARE (ESX/ESXi) host. Provided by the vSphere API.',
	);

	$TIPS[]=array(
		'id_ref' => 'xagt_004535',
		'tip_type' => 'agent',
		'name' => 'Descripcion',
		'descr' => 'Provides the physical device (LUN) SCSI commands latency of an VMWARE (ESX/ESXi) host. Provided by the vSphere API.',
	);

	$TIPS[]=array(
		'id_ref' => 'xagt_004536',
		'tip_type' => 'agent',
		'name' => 'Descripcion',
		'descr' => 'Provides the number of received and transmitted packets of an VMWARE (ESX/ESXi) host. Provided by the vSphere API.',
	);

	$TIPS[]=array(
		'id_ref' => 'xagt_004537',
		'tip_type' => 'agent',
		'name' => 'Descripcion',
		'descr' => 'Provides the number of discarded and error packets of an VMWARE (ESX/ESXi) host. Provided by the vSphere API.',
	);

?>
