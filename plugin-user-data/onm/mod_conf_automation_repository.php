<?php
include_once('include_basic.php');


define('_do','custom/mod_conf_automation_repository');
define('_hidx',CNMUtils::get_param('hidx'));
define('SESIONPHP',session_id());

$accion = CNMUtils::get_param('accion')!=''?CNMUtils::get_param('accion'):'open';

if ($accion=='open')         action('open','open');
elseif($accion=='get_table') action('get_table');

function open(){
	$xml_table = get_table(1);
	
   $array_tpl = array('SESIONPHP'=>SESIONPHP,'hidx'=>_hidx,'do'=>_do,'xml_table'=>$xml_table);
   $array_tpl   = array_merge($array_tpl,$GLOBALS['mc']->msg());
   new template('shtml/mod_conf_automation_repository.shtml',$array_tpl);
}

function get_table($mode=0){
   $tabla = new Table();
   $tabla->addCol(array('type'=>'ro','width'=>'120','sort'=>'int','align'=>'left'),'',i18('_fecha'));
   $tabla->addCol(array('type'=>'ro','width'=>'180','sort'=>'str','align'=>'left'),'',i18('_nombre'));
   $tabla->addCol(array('type'=>'ro','width'=>'50','sort'=>'str','align'=>'center'),'',i18('_estado'));
   $tabla->addCol(array('type'=>'ro','width'=>'60','sort'=>'str','align'=>'left'),'',i18('_tamano'));
   $tabla->addCol(array('type'=>'ro','width'=>'*','sort'=>'str','align'=>'left'),'',i18('_lineas'));
   $data = array();


   $cont = 1;
   $dirToScan = '/var/www/html/onm/user/automation';
   $dirToScanRel = 'user/automation';

   $files = scandir($dirToScan);
   foreach($files as $file) {
      if ($file=='.' or $file=='..' or is_dir("$dirToScan/$file") or (strpos($file,'in_progress')!=false))continue;
      $fileFullPath = "$dirToScan/$file";
      $fileFullPathRel = "$dirToScanRel/$file";

      $mtimeArray = getdate(filemtime($fileFullPath));
      $fsize = filesize($fileFullPath);
		$ftype = mime_content_type($fileFullPath);
		if ($ftype == 'text/plain') {
			$flines = count(file($fileFullPath)) - 1;  // Si el fichero fuera muy largo esto puede tener problemas de memoria
		}
		else { $flines = '-'; }
      //format date as yyyy-m-d hh:mm:ss
      $fdate = sprintf("%04s-%02s-%02s %02s:%02s:%02s", $mtimeArray["year"],$mtimeArray["mon"],$mtimeArray["mday"],$mtimeArray["hours"],$mtimeArray["minutes"],$mtimeArray["seconds"]);

		CNMUtils::info_log(__FILE__, __LINE__, "get_table  >> --$fileFullPath--$fileFullPathRel--$ftype|$flines");

      $row_meta = array('id'=>$cont);
		$status = (file_exists($fileFullPath.".in_progress")?'...':i18('_OK'));
      // $row_data = array($fdate,"$file^$fileFullPath^_self",$status,$fsize);
		$link = "<a href='do.php?hidx="._hidx."&do=$fileFullPathRel&PHPSESSID=".SESIONPHP."'>$file</a>";
		
      $row_data = array($fdate,$link,$status,$fsize,$flines);
      $row_user = array();
      $tabla->addRow($row_meta,$row_data,$row_user);
      $cont++;
   }
   if($mode==0) $tabla->show();
	else return  $tabla->xml();
}

?>
