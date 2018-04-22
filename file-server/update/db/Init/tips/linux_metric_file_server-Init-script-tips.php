<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_file_server.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Checks File Server Operation 
The script copies the number of files (text files) specified (default is 10) to the server and then copies back from the server checking the integrity of the received files.

It provides two metrics:

<001> File Transfer Latency (sg) = 7.350022
<002> File Transfer Success (%) = 100

File Transfer Latency show the time consumed in the overall operation.
File Transfer Success show the percent of success in file transfers.

The parameters are:

 linux_metric_file_server.pl -host 1.1.1.1 -user user1 -pwd xxx [-port 22|...] [-proto sftp|...] [-files 10|...] [-size 100000|...] [-v]
 linux_metric_file_server.pl -h  : Help

 -host       : File Server Host
 -port       : Port (default 22)
 -user       : Server User
 -pwd        : Server User Password
 -proto      : Protocol (default sftp)
 -files      : Number of files used (tx/rx). Default is 10.
 -size       : Aggregated size. Default is 300KB.
 -v/-verbose : Verbose output (debug)
 -h/-help    : Help
',
      );

?>
