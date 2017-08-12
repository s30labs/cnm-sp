<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_ipmi_sensors.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este script obtiene la información que reporta un equipo a través de IPMI.

linux_metric_ipmi_sensors.pl v1.0

linux_metric_ipmi_sensors.pl -n IP/Host -u Usuario -p Clave [-t timeout] [-r revision] [-s tipo de sensor]
linux_metric_ipmi_sensors.pl -h

-n    Host (Nombre a resolver)
-t 	Timeout (opcional)
-b		Genera alerta azul
-r    Versión IPMI. Las opciones posibles son 1.5 y 2.0. Por defecto se hace con 1.5
-u    Nombre de usuario
-p    Clave
-h    Ayuda
-s    Tipo de sensor. En caso de no indicarlo devuelve todos. Los sensores disponibles son:
      - temperature
      - voltage
      - current
      - fan
      - physical_security
      - platform_security_violation_attempt
      - processor
      - power_supply
      - power_unit
      - memory
      - drive_slot
      - system_firmware_progress
      - event_logging_disabled
      - system_event
      - critical_interrupt
      - module_board
      - slot_connector
      - watchdog2
      - entity_presence
      - management_subsystem_health
      - battery
      - fru_state
      - cable_interconnect
      - boot_error
      - button_switch
      - system_acpi_power_state
',
      );

?>
