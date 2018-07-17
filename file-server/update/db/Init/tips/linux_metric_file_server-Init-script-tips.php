<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_file_server.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Checks File Server Operation 
The script copies the number of files (text files) specified (default is 10) to the server and then copies back from the server checking the integrity of the received files.

It provides several metrics depending on the action value:

action=test
<001> File Transfer Latency (sg) = 7.350022
<001RC> STATUS - File Transfer Latency (sg) = 0
<002> File Transfer Success (%) = 100
<002RC> STATUS - File Transfer Success (%) = 0

action=count
<003> Number of Files = unk
<003RC> STATUS - Number of Files = 0

action=last
<004> Last File Modification Time = 118224
<004RC> STATUS - Last File Modification Time = 0

File Transfer Latency show the time consumed in the test overall operation.
File Transfer Success show the percent of success in the test file transfers.
Number of Files counts the files on directory
Last File Modification Time shows the delta time with the current time
The parameters are:

 linux_metric_file_server.pl -host 1.1.1.1 -user user1 -pwd xxx [-port 22|...] [-proto sftp|...] [-action test] [-files 10|...] [-size 100000|...] [-v]
 linux_metric_file_server.pl -host 1.1.1.1 -user user1 -pwd xxx [-port 22|...] [-proto sftp|...] -action count [-remotedir /dir1/xx] [-v]
 linux_metric_file_server.pl -host 1.1.1.1 -user user1 -pwd xxx [-port 22|...] [-proto sftp|...] -action last [-remotedir /dir1/xx] [-lapse 3600] [-v]
 linux_metric_file_server.pl -h  : Help

 -host       : File Server Host
 -port       : Port (default 22)
 -user       : Server User
 -pwd        : Server User Password
 -proto      : Protocol (default sftp)
 -action     : test|count|last
 -files      : Number of files used (tx/rx). Default is 10. (mode=test)
 -size       : Aggregated size. Default is 300KB. (mode=test)
 -remotedir  : Remote directory  (mode=count|test)
 -lapse      : Tnow-lapse  (mode=count)
 -timeout    : Max. Timeout [Default 20 sg]
 -v/-verbose : Verbose output (debug)
 -h/-help    : Help
',
      );

?>
