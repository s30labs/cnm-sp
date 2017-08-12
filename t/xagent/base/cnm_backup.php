#!/usr/bin/php
<?php
	include_once('/var/www/html/onm/inc/Backup.php');
	$a_rc = do_backup();

	if($a_rc['rc']==0){
		fwrite(STDOUT, $a_rc['data']);
		fwrite(STDERR, $a_rc['msg']);
		exit(0);
	}
	else{
		fwrite(STDERR, $a_rc['msg']);
		exit(1);
	}
?>
