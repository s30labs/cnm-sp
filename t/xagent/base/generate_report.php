#!/usr/bin/php
<?php
	include_once('/var/www/html/onm/inc/report.php');
/*
   $subtype_cfg_report = $input['subtype_cfg_report'];
   $date_start         = $input['date_start'];
   $date_end           = $input['date_end'];
   $type               = $input['type'];
   $name               = $input['name'];
*/
	$opts = getopt("s:e:hn:i:");
	if(isset($opts['h']))help();
	else{
		if($opts['e']==''){
			echo("Debe indicar el parámetro -e\n");
			help();
			exit();
		}
		else{
			if(strtolower($opts['e'])=='now'){
				$date_end=time();
			}
			elseif(preg_match('/^(\d+)$/',$opts['e'], $coincidencias)){
				$date_end=$opts['e'];
			}
			else{
				echo("El parámetro -e debe ser un timestamp o now\n");
				help();
				exit();
			}
		}

		if($opts['s']==''){
			echo("Debe indicar el parámetro -s\n");
			help();
         exit();
		}
		else{
			if(preg_match('/^(\d+)[hH]$/',$opts['s'], $coincidencias))     $date_start=$date_end-($coincidencias[1]*3600);
			elseif(preg_match('/^(\d+)[dD]$/',$opts['s'], $coincidencias)) $date_start=$date_end-($coincidencias[1]*86400);
			elseif(preg_match('/^(\d+)[wW]$/',$opts['s'], $coincidencias)) $date_start=$date_end-($coincidencias[1]*604800);
         elseif(preg_match('/^(\d+)[mM]$/',$opts['s'], $coincidencias)) $date_start=$date_end-($coincidencias[1]*2592000);
			elseif(preg_match('/^(\d+)[yY]$/',$opts['s'], $coincidencias)) $date_start=$date_end-($coincidencias[1]*31536000);
			elseif(preg_match('/^(\d+)$/',$opts['s'], $coincidencias))     $date_start=$opts['s'];
			else{
				echo("El formato del parámetro -s no es correcto\n");
				help();
				exit;
			}
		}
		if($opts['i']==''){
			echo("Debe indicar el parámetro -i\n");
			help();
			exit;
		}
      $data = array(
         'subtype_cfg_report' => $opts['i'],
         'date_start'         => $date_start,
         'date_end'           => $date_end,
         'type'               => 'fromto',
         'name'               => $opts['n']
      );
		$id = save_report($data);
		// print "/var/www/html/onm/mod_show_report_ext.php?id=$id";

		$local_ip = local_ip();
		$my_url="";
	   $entrada = array('WWW_SERVER_URL'=>'');
	   $Mensaje=read_cfg_file('/cfg/onm.conf',$entrada);
		$a_www_server_url=explode(',',$entrada['WWW_SERVER_URL']);
		foreach($a_www_server_url as $www_server_url){
			if($www_server_url=='') continue;
			$my_url .= "$www_server_url/mod_show_report_ext.php?id=$id\n";
		}

		if ($my_url == "") { $my_url="http://$local_ip/onm/mod_show_report_ext.php?id=$id\n"; }
		print $my_url;

	}
/*
	else help();
*/

function help(){
   echo
"generate_report.php
parámetros:
   -e [timestamp] => timestamp que representa la fecha final del informe o now
   -s [timestamp] => timestamp que representa la fecha inicial del informe o el tiempo relativo al parámetro -e:
                      xH => x horas
                      xD => x dias
                      xW => x semanas
                      xM => x meses
                      xY => x años
   -n [nombre_report] => Nombre con el que se va a almacenar el informe
   -i [id_report] => Identificador interno de la plantilla que se va a utilizar para generar el informe
   -h => Muestra esta ayuda\n";
}
?>
