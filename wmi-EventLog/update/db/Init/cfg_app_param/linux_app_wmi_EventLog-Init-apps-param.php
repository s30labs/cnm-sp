<?php
      $CFG_APP_PARAM[]=array(
         'aname' => 'app_get_event_log', 'hparam' => '2b773626', 'type' => 'xagent', 'enable' => '1', 'value' => '',
         'script' => 'linux_app_wmi_EventLog.pl',
      );

      $CFG_APP_PARAM[]=array(
         'aname' => 'app_get_event_log', 'hparam' => '4c694901', 'type' => 'xagent', 'enable' => '1', 'value' => '$sec.wmi.user',
         'script' => 'linux_app_wmi_EventLog.pl',
      );

      $CFG_APP_PARAM[]=array(
         'aname' => 'app_get_event_log', 'hparam' => '42cee444', 'type' => 'xagent', 'enable' => '1', 'value' => '$sec.wmi.pwd',
         'script' => 'linux_app_wmi_EventLog.pl',
      );

?>
