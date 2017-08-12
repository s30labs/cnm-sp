<?php
      $CFG_MONITOR_APPS[]=array(
         'type' => 'xagent', 'subtype'=>'Linux',  'name'=>'LINUX NET CONFIG A SYSLOG',
         'descr' => '',
         'cmd' => '',
         'params' => '',      'iptab'=>'1', 'ready'=>'1',
         'myrange' => '',   'enterprise'=>'0',
         'cfg' => '0',  'platform' => 'Linux',   'script' => 'linux_app_ssh_syslog.pl',   'format'=>1,
         'custom' => '0', 'aname'=> 'app_linux_net_config_to_syslog', 'res'=>1, 'ipparam'=>'',
         'apptype' => 'SO.LINUX',  'itil_type' => '1'
      );

      $CFG_MONITOR_APPS[]=array(
         'type' => 'xagent', 'subtype'=>'Linux',  'name'=>'CALL MANAGER DIAGNOSE TEST A SYSLOG',
         'descr' => '',
         'cmd' => '',
         'params' => '',      'iptab'=>'1', 'ready'=>'1',
         'myrange' => '',   'enterprise'=>'0',
         'cfg' => '0',  'platform' => 'Linux',   'script' => 'linux_app_ssh_syslog.pl',   'format'=>1,
         'custom' => '0', 'aname'=> 'app_ccm_diag_to_syslog', 'res'=>1, 'ipparam'=>'',
         'apptype' => 'NET.CISCO',  'itil_type' => '1'
      );

?>
