<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_db_mssqlCmd.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Allows SQL command execution on Microsoft SQL Server. Useful for creating custom metrics returning a numeric value.

The parameters are:

 linux_metric_db_mssqlCmd.pl -host 1.1.1.1 -db MYDATABASE -user user1 -pwd mysecret -sqlcmd "SET NOCOUNT ON;SELECT COUNT(xx) AS "001" FROM ttt FOR JSON AUTO" [-port 1433] [-tag 001] [-label "Number of users"]
 linux_metric_db_mssqlCmd.pl -h  : Help

 -host       : Database Server Host
 -port       : Port (default 1433)
 -user       : DB User
 -pwd        : DB User Password
 -sqlcmd     : SQL Sentence
 -tag        : Tag associated with the metric
 -label      : Label associated with the metric
 -cols       : Columns of the query. Separated by ;
 -v/-verbose : Verbose output (debug)
 -h/-help    : Help

 linux_metric_db_mssqlCmd.pl -n 1.1.1.1 [-port 2322]
 linux_metric_db_mssqlCmd.pl -n 1.1.1.1 -user=aaa -pwd=bbb
 linux_metric_db_mssqlCmd.pl -n 1.1.1.1 -user=aaa -key_file=/etc/ssh/id_rsa
 linux_metric_db_mssqlCmd.pl -n 1.1.1.1 -user=aaa -key_file=1
 linux_metric_db_mssqlCmd.pl -h  : Ayuda
',
      );

?>
