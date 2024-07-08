<?php
$PLUGIN_BASE = array(

   // Rama en el árbol de configuración
	// 'plugin_id' => 5
   array(
      'html_id'   => 'conf_tree',
      'html_type' => 'tree',
      'label'     => 'Datos de Usuario',
      'icon'      => 'mod_rama24x24.png',
      'size'      => '24px',
      'target'    => '',
      'position'  => 1005,
      'plugin_id' => 5,
      'parent'    => '',
      'item_id'   => 'conf_tab_file_store',
      'item_type' => '-',
   ),
   array(
      'html_id'   => 'conf_tree',
      'html_type' => 'tree',
      'label'     => 'Ficheros de Configuración',
      'icon'      => 'mod_rama24x24.png',
      'size'      => '24px',
      'target'    => 'custom/mod_conf_file_repository',
      'position'  => 1,
      'plugin_id' => 5,
      'parent'    => 'conf_tab_file_store',
      'item_id'   => 'conf_tab_file_repository',
      'item_type' => '-',
   ),
/*
   array(
      'html_id'   => 'conf_tree',
      'html_type' => 'tree',
      'label'     => 'Ficheros de Automatización',
      'icon'      => 'mod_rama24x24.png',
      'size'      => '24px',
      'target'    => 'custom/mod_conf_automation_repository',
      'position'  => 2,
      'plugin_id' => 5,
      'parent'    => 'conf_tab_file_store',
      'item_id'   => 'conf_tab_automation_repository',
      'item_type' => '-',
   ),
   array(
      'html_id'   => 'conf_tree',
      'html_type' => 'tree',
      'label'     => 'Ficheros de Calendario',
      'icon'      => 'mod_rama24x24.png',
      'size'      => '24px',
      'target'    => 'custom/mod_conf_calendar_repository',
      'position'  => 3,
      'plugin_id' => 5,
      'parent'    => 'conf_tab_file_store',
      'item_id'   => 'conf_tab_calendar_repository',
      'item_type' => '-',
   ),
*/

);
?>
