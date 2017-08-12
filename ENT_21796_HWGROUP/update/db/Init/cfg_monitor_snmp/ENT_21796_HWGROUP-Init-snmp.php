<?php

		$CFG_MONITOR_SNMP[]=array(
            'subtype' => 'hwg_ste_status',
            'class' => 'HWGROUP',
            'lapse' => '300',
            'descr' => 'ESTADO DEL SENSOR',
            'items' => 'Ok(1)|OutLo(2)|OutHi(3)|AlarmLo(4)|AlarmHi(5)|Inv(0)',
            'oid' => '.1.3.6.1.4.1.21796.4.1.3.1.3.IID',
            'get_iid' => 'sensName',
            'oidn' => 'sensState.IID',
            'oid_info' => '',
            'module' => 'mod_snmp_get',
            'mtype' => 'STD_SOLID',
            'vlabel' => 'num',
            'mode' => 'GAUGE',
            'top_value' => '1',
            'cfg' => '2',
            'custom' => '0',
            'include' => '1',
            'myrange' => 'STE-MIB::sensTable',
            'enterprise' => '21796',
            'esp' => 'MAP(1)(1,0,0,0,0,0)|MAP(2)(0,1,0,0,0,0)|MAP(3)(0,0,1,0,0,0)|MAP(4)(0,0,0,1,0,0)|MAP(5)(0,0,0,0,1,0)|MAP(0)(0,0,0,0,0,1)',
            'params' => '',
            'itil_type' => '3',
            'apptype' => 'NET.HWGROUP',
      );



		$CFG_MONITOR_SNMP[]=array(
            'subtype' => 'hwg_ste_temp',
            'class' => 'HWGROUP',
            'lapse' => '300',
            'descr' => 'VALOR DEL SENSOR HWG',
            'items' => 'Valor',
            'oid' => '.1.3.6.1.4.1.21796.4.1.3.1.5.IID',
            'get_iid' => 'sensName',
            'oidn' => 'sensValue.IID',
            'oid_info' => '',
            'module' => 'mod_snmp_get',
            'mtype' => 'STD_BASE',
            'vlabel' => 'num',
            'mode' => 'GAUGE',
            'top_value' => '1',
            'cfg' => '2',
            'custom' => '0',
            'include' => '1',
            'myrange' => 'STE-MIB::sensTable',
            'enterprise' => '21796',
            'esp' => 'o1/10',
            'params' => '',
            'itil_type' => '1',
            'apptype' => 'NET.HWGROUP',
      );


?>
