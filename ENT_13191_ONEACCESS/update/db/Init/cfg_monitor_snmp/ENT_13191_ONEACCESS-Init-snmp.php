<?php

		$CFG_MONITOR_SNMP[]=array(
            'subtype' => 'oneaccess_mem_total',
            'class' => 'ONEACCESS',
            'lapse' => '300',
            'descr' => 'USO DE MEMORIA',
            'items' => 'oacSysMemoryUsed.0',
            'oid' => '.1.3.6.1.4.1.13191.10.3.3.1.1.4.0',
            'get_iid' => '',
            'oidn' => 'ONEACCESS-SYS-MIB::oacSysMemoryUsed.0',
            'oid_info' => '',
            'module' => 'mod_snmp_get',
            'mtype' => 'STD_BASE',
            'vlabel' => 'num',
            'mode' => 'GAUGE',
            'top_value' => '1',
            'cfg' => '1',
            'custom' => '0',
            'include' => '1',
            'myrange' => 'ONEACCESS-SYS-MIB::oacSysMemoryUsed.0',
            'enterprise' => '13191',
            'esp' => '',
            'params' => '',
            'itil_type' => '1',
            'apptype' => 'NET.ONEACCESS',
      );



		$CFG_MONITOR_SNMP[]=array(
            'subtype' => 'oneaccess_cpu_usage',
            'class' => 'ONEACCESS',
            'lapse' => '300',
            'descr' => 'USO DE CPU',
            'items' => 'oacSysCpuUsedOneMinuteValue',
            'oid' => '.1.3.6.1.4.1.13191.10.3.3.1.2.3.1.4.IID',
            'get_iid' => 'oacSysCpuUsedIndex',
            'oidn' => 'oacSysCpuUsedOneMinuteValue.IID',
            'oid_info' => '',
            'module' => 'mod_snmp_get',
            'mtype' => 'STD_BASE',
            'vlabel' => 'num',
            'mode' => 'GAUGE',
            'top_value' => '1',
            'cfg' => '2',
            'custom' => '0',
            'include' => '1',
            'myrange' => 'ONEACCESS-SYS-MIB::oacSysCpuUsedCoresTable',
            'enterprise' => '13191',
            'esp' => '',
            'params' => '',
            'itil_type' => '1',
            'apptype' => 'NET.ONEACCESS',
      );



		$CFG_MONITOR_SNMP[]=array(
            'subtype' => 'oneaccess_radio_params',
            'class' => 'ONEACCESS',
            'lapse' => '300',
            'descr' => 'PARAMETROS RADIO',
            'items' => 'oacCellSignalStrength|oacCellRSRQ|oacCellRSRP|oacCellSNR',
            'oid' => '.1.3.6.1.4.1.13191.10.3.9.2.1.41.IID|.1.3.6.1.4.1.13191.10.3.9.2.1.43.IID|.1.3.6.1.4.1.13191.10.3.9.2.1.44.IID|.1.3.6.1.4.1.13191.10.3.9.2.1.45.IID',
            'get_iid' => 'oacCellModuleIndex',
            'oidn' => 'oacCellSignalStrength.IID|oacCellRSRQ.IID|oacCellRSRP.IID|oacCellSNR.IID',
            'oid_info' => '',
            'module' => 'mod_snmp_get',
            'mtype' => 'STD_BASE',
            'vlabel' => 'num',
            'mode' => 'GAUGE',
            'top_value' => '1',
            'cfg' => '2',
            'custom' => '0',
            'include' => '1',
            'myrange' => 'ONEACCESS-CELLULAR-MIB::oacCellRadioModuleTable',
            'enterprise' => '13191',
            'esp' => '',
            'params' => '',
            'itil_type' => '1',
            'apptype' => 'NET.ONEACCESS',
      );


?>
