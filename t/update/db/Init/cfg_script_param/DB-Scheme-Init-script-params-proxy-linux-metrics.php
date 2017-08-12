<?php
/*

param_type => 0:Normal 1:Securizado 2:IP/HOST

Pasos a seguir:

1. Poner el valor adecuado de hparam (debe ser unico)
2. Incrementar position 0,1,2 ....
3. Poner bien param_type 0(Normal),1(pwd),2(IP)
4. Poner el nombre del script
5. Poner (si es necesario) el prefix de los parametros
6. Poner la descripcion de los parametros
7. Poner el valor por defecto de los parametros

*/
//---------------------------------------------------------------------------------------------------------
// PARAMETROS DE SCRIPTS PROXY-LINUX
// xagt_004000-xagt_004999
//---------------------------------------------------------------------------------------------------------

//linux_metric_certificate_expiration_time.pl
//[;IP;]:[;Puerto;443]
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000000', 'position' => '0', 'param_type' => '2',
		'script' => 'linux_metric_certificate_expiration_time.pl',
		'prefix' => '', 'descr' => 'IP', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000001', 'position' => '1', 'param_type' => '0',
      'script' => 'linux_metric_certificate_expiration_time.pl',
      'prefix' => '', 'descr' => 'Puerto', 'value' => '443',
   );

//linux_metric_mail_loop.pl
//[-mxhost;Host SMTP;]:[-to;Destinatario del correo;]:[-from;Origen del correo;]:[-pop3host;Host POP3;]:[-user;Usuario POP3;]:[-pwd;Clave POP3;]:[-n;Numero de correos a enviar;3]
/*
-mxhost: Host SMTP
-mxport: Puerto SMTP
-to:     Campo to del correo
-from:   Campo from del correo
-txuser: Usuario SMTP (Si es SMTP Autenticado)
-txpwd:  Clave del usuario SMTP (Si es SMTP Autenticado)
-tls:    Si se especifica, indica que el envio es con TLS
-tlsa:   Si se especifica, indica que el envio es con TLS + AUTH
-pop3host: Host POP3
-pop3port: Puerto POP3
-user:   Usuario POP3
-pwd:    Clave del usuario POP3
-n:      Numero de correos que se envian
*/
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000010', 'position' => '0', 'param_type' => '2',
      'script' => 'linux_metric_mail_loop.pl',
      'prefix' => '-mxhost', 'descr' => 'Host SMTP', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000011', 'position' => '1', 'param_type' => '0',
      'script' => 'linux_metric_mail_loop.pl',
      'prefix' => '-mxport', 'descr' => 'Puerto del servidor SMTP', 'value' => '25',
   );

   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000012', 'position' => '2', 'param_type' => '0',
      'script' => 'linux_metric_mail_loop.pl',
      'prefix' => '-to', 'descr' => 'Destinatario del correo', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000013', 'position' => '3', 'param_type' => '0',
      'script' => 'linux_metric_mail_loop.pl',
      'prefix' => '-from', 'descr' => 'Origen del correo', 'value' => '',
   );

   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000014', 'position' => '4', 'param_type' => '0',
      'script' => 'linux_metric_mail_loop.pl',
      'prefix' => '-tls', 'descr' => 'Usa TLS', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000015', 'position' => '5', 'param_type' => '0',
      'script' => 'linux_metric_mail_loop.pl',
      'prefix' => '-tlsa', 'descr' => 'Usa TLS+Auth', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000016', 'position' => '6', 'param_type' => '1',
      'script' => 'linux_metric_mail_loop.pl',
      'prefix' => '-txuser', 'descr' => 'Usuario para SMTP con Auth', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000017', 'position' => '7', 'param_type' => '1',
      'script' => 'linux_metric_mail_loop.pl',
      'prefix' => '-txpwd', 'descr' => 'Clave para SMTP con Auth', 'value' => '',
   );

   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000018', 'position' => '8', 'param_type' => '0',
      'script' => 'linux_metric_mail_loop.pl',
      'prefix' => '-pop3host', 'descr' => 'Host POP3', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000019', 'position' => '9', 'param_type' => '0',
      'script' => 'linux_metric_mail_loop.pl',
      'prefix' => '-pop3port', 'descr' => 'Host POP3', 'value' => '110',
   );

   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '0000001a', 'position' => '10', 'param_type' => '1',
      'script' => 'linux_metric_mail_loop.pl',
      'prefix' => '-user', 'descr' => 'Usuario POP3', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '0000001b', 'position' => '11', 'param_type' => '1',
      'script' => 'linux_metric_mail_loop.pl',
      'prefix' => '-pwd', 'descr' => 'Clave POP3', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '0000001c', 'position' => '12', 'param_type' => '0',
      'script' => 'linux_metric_mail_loop.pl',
      'prefix' => '-n', 'descr' => 'Numero de correos a enviar', 'value' => '3',
   );

//linux_metric_mysql_var.pl
//[-host;Host con MySQL;]:[-user;Usuario de acceso;]:[-pwd;Clave del usuario;]
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000020', 'position' => '0', 'param_type' => '2',
      'script' => 'linux_metric_mysql_var.pl',
      'prefix' => '-host', 'descr' => 'Host con MySQL', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000021', 'position' => '1', 'param_type' => '1',
      'script' => 'linux_metric_mysql_var.pl',
      'prefix' => '-user', 'descr' => 'Usuario de acceso', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000022', 'position' => '2', 'param_type' => '1',
      'script' => 'linux_metric_mysql_var.pl',
      'prefix' => '-pwd', 'descr' => 'Clave del usuario', 'value' => '',
   );

//linux_metric_ssh_files_in_dir.pl
//[-n;Host;]:[-u;User;]:[-p;Password;]:[-d;Directorio;]:[-a;Patron;]
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000030', 'position' => '0', 'param_type' => '2',
      'script' => 'linux_metric_ssh_files_in_dir.pl',
      'prefix' => '-n', 'descr' => 'Host', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000031', 'position' => '1', 'param_type' => '1',
      'script' => 'linux_metric_ssh_files_in_dir.pl',
      'prefix' => '-u', 'descr' => 'User', 'value' => '$sec.ssh.user',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000032', 'position' => '2', 'param_type' => '1',
      'script' => 'linux_metric_ssh_files_in_dir.pl',
      'prefix' => '-p', 'descr' => 'Password', 'value' => '$sec.ssh.pwd',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000033', 'position' => '3', 'param_type' => '0',
      'script' => 'linux_metric_ssh_files_in_dir.pl',
      'prefix' => '-d', 'descr' => 'Directorio', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000034', 'position' => '4', 'param_type' => '0',
      'script' => 'linux_metric_ssh_files_in_dir.pl',
      'prefix' => '-a', 'descr' => 'Patron', 'value' => '',
   );

//linux_metric_ssh_files_per_proccess.pl
//[-n;Host;]:[-u;User;]:[-p;Password;]
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000040', 'position' => '0', 'param_type' => '2',
      'script' => 'linux_metric_ssh_files_per_proccess.pl',
      'prefix' => '-n', 'descr' => 'Host', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000041', 'position' => '1', 'param_type' => '1',
      'script' => 'linux_metric_ssh_files_per_proccess.pl',
      'prefix' => '-u', 'descr' => 'User', 'value' => '$sec.ssh.user',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000042', 'position' => '2', 'param_type' => '1',
      'script' => 'linux_metric_ssh_files_per_proccess.pl',
      'prefix' => '-p', 'descr' => 'Password', 'value' => '$sec.ssh.pwd',
   );

//linux_metric_route_tag.pl (MULTIMETRICA)
//[-host;Host;]
//<001> Route Tag = 317488
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000050', 'position' => '0', 'param_type' => '2',
      'script' => 'linux_metric_route_tag.pl',
      'prefix' => '-host', 'descr' => 'Host', 'value' => '',
   );


//linux_metric_snmp_count_proc_multiple_devices.pl
//<apache2> Num. procesos [apache2] = 18
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000055', 'position' => '0', 'param_type' => '2',
      'script' => 'linux_metric_snmp_count_proc_multiple_devices.pl',
      'prefix' => '-n', 'descr' => 'Host', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000056', 'position' => '1', 'param_type' => '0',
      'script' => 'linux_metric_snmp_count_proc_multiple_devices.pl',
      'prefix' => '-r', 'descr' => 'Resto de equipos', 'value' => '',
   );

//linux_metric_mon_dns.pl -n host [-r recurso RR] [-p port] : Chequea dns
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000060', 'position' => '0', 'param_type' => '2',
      'script' => 'linux_metric_mon_dns.pl',
      'prefix' => '-n', 'descr' => 'Host', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000061', 'position' => '1', 'param_type' => '0',
      'script' => 'linux_metric_mon_dns.pl',
      'prefix' => '-r', 'descr' => 'Recurso (RR) del DNS', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000062', 'position' => '2', 'param_type' => '0',
      'script' => 'linux_metric_mon_dns.pl',
      'prefix' => '-p', 'descr' => 'Puerto', 'value' => '53',
   );


//linux_metric_mon_http_uri_response.pl -u url [-t get|post -e extra_params -p port]
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000069', 'position' => '0', 'param_type' => '2',
      'script' => 'linux_metric_mon_http_uri_response.pl',
      'prefix' => '-n', 'descr' => 'Host', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000070', 'position' => '1', 'param_type' => '0',
      'script' => 'linux_metric_mon_http_uri_response.pl',
      'prefix' => '-u', 'descr' => 'URL', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000071', 'position' => '2', 'param_type' => '0',
      'script' => 'linux_metric_mon_http_uri_response.pl',
      'prefix' => '-p', 'descr' => 'Puerto', 'value' => '80',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000072', 'position' => '3', 'param_type' => '0',
      'script' => 'linux_metric_mon_http_uri_response.pl',
      'prefix' => '-t', 'descr' => 'Tipo (get/post)', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000073', 'position' => '4', 'param_type' => '0',
      'script' => 'linux_metric_mon_http_uri_response.pl',
      'prefix' => '-e', 'descr' => 'Parametros Extra', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000074', 'position' => '5', 'param_type' => '0',
      'script' => 'linux_metric_mon_http_uri_response.pl',
      'prefix' => '-use_proxy', 'descr' => 'Usa Proxy (1/0)', 'value' => '0',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000075', 'position' => '6', 'param_type' => '0',
      'script' => 'linux_metric_mon_http_uri_response.pl',
      'prefix' => '-proxy_user', 'descr' => 'Usuario de Proxy', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000076', 'position' => '7', 'param_type' => '0',
      'script' => 'linux_metric_mon_http_uri_response.pl',
      'prefix' => '-proxy_pwd', 'descr' => 'Clave Usuario de Proxy', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000077', 'position' => '8', 'param_type' => '0',
      'script' => 'linux_metric_mon_http_uri_response.pl',
      'prefix' => '-proxy_host', 'descr' => 'Host Proxy', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000078', 'position' => '9', 'param_type' => '0',
      'script' => 'linux_metric_mon_http_uri_response.pl',
      'prefix' => '-proxy_port', 'descr' => 'Puerto Proxy', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000079', 'position' => '10', 'param_type' => '0',
      'script' => 'linux_metric_mon_http_uri_response.pl',
      'prefix' => '-use_realm', 'descr' => 'Usa Realm (Autenticacion) (1/0)', 'value' => '0',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000080', 'position' => '11', 'param_type' => '0',
      'script' => 'linux_metric_mon_http_uri_response.pl',
      'prefix' => '-realm_user', 'descr' => 'Usuario de Acceso', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000081', 'position' => '12', 'param_type' => '0',
      'script' => 'linux_metric_mon_http_uri_response.pl',
      'prefix' => '-realm_pwd', 'descr' => 'Clave del usuario de Acceso', 'value' => '',
   );

//linux_metric_mon_imap.pl -n host -u user -c password [-p port] : Chequea imap
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000090', 'position' => '0', 'param_type' => '2',
      'script' => 'linux_metric_mon_imap.pl',
      'prefix' => '-n', 'descr' => 'Host', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000091', 'position' => '1', 'param_type' => '0',
      'script' => 'linux_metric_mon_imap.pl',
      'prefix' => '-u', 'descr' => 'Usuario', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000092', 'position' => '2', 'param_type' => '1',
      'script' => 'linux_metric_mon_imap.pl',
      'prefix' => '-c', 'descr' => 'Clave', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000093', 'position' => '3', 'param_type' => '0',
      'script' => 'linux_metric_mon_imap.pl',
      'prefix' => '-p', 'descr' => 'Puerto', 'value' => '143',
   );

//linux_metric_mon_pop3.pl -n host -u user -c password [-p port] : Chequea pop3
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000100', 'position' => '0', 'param_type' => '2',
      'script' => 'linux_metric_mon_pop3.pl',
      'prefix' => '-n', 'descr' => 'Host', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000101', 'position' => '1', 'param_type' => '0',
      'script' => 'linux_metric_mon_pop3.pl',
      'prefix' => '-u', 'descr' => 'Usuario', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000102', 'position' => '2', 'param_type' => '1',
      'script' => 'linux_metric_mon_pop3.pl',
      'prefix' => '-c', 'descr' => 'Clave', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000103', 'position' => '3', 'param_type' => '0',
      'script' => 'linux_metric_mon_pop3.pl',
      'prefix' => '-p', 'descr' => 'Puerto', 'value' => '',
   );

//linux_metric_mon_smtp.pl -n host [-p port] : Chequea smtp
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000110', 'position' => '0', 'param_type' => '2',
      'script' => 'linux_metric_mon_smtp.pl',
      'prefix' => '-n', 'descr' => 'Host', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000111', 'position' => '1', 'param_type' => '0',
      'script' => 'linux_metric_mon_smtp.pl',
      'prefix' => '-p', 'descr' => 'Puerto', 'value' => '',
   );



//linux_metric_wmi_perfOS.pl -n IP -u user -p pwd -d domain : Chequea mediante WMI
/*   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000120', 'position' => '0', 'param_type' => '2',
      'script' => 'linux_metric_wmi_perfOS.pl',
      'prefix' => '-n', 'descr' => 'Host', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000121', 'position' => '1', 'param_type' => '1',
      'script' => 'linux_metric_wmi_perfOS.pl',
      'prefix' => '-u', 'descr' => 'Usuario', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000122', 'position' => '2', 'param_type' => '1',
      'script' => 'linux_metric_wmi_perfOS.pl',
      'prefix' => '-p', 'descr' => 'Clave', 'value' => '',
   );
   $CFG_SCRIPT_PARAM[]=array(
      'hparam' => '00000123', 'position' => '3', 'param_type' => '0',
      'script' => 'linux_metric_wmi_perfOS.pl',
      'prefix' => '-d', 'descr' => 'Dominio', 'value' => '',
   );
*/

?>
