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
<003> Total Files = 8587
<003.CM_> Total Files (CM_) = 1454
<003.MP_> Total Files (MP_) = 2565
<003.SS_> Total Files (SS_) = 1988
<003.ST_> Total Files (ST_) = 2580
<003RC> STATUS - Total Files = 0
<004> Latest File Modification Time = 1532026296
<004RC> STATUS - Latest File Modification Time = 0
<005> Oldest File Modification Time = 1529624299
<005RC> STATUS - Oldest File Modification Time = 0
<006> Total Files before lapse = 8559
<006.CM_> Total Files before lapse (CM_) = 1449
<006.MP_> Total Files before lapse (MP_) = 2557
<006.SS_> Total Files before lapse (SS_) = 1981
<006.ST_> Total Files before lapse (ST_) = 2572
<006RC> STATUS - Total Files before lapse = 0
<007> Total Files after lapse = 28
<007.CM_> Total Files after lapse (CM_) = 5
<007.MP_> Total Files after lapse (MP_) = 8
<007.SS_> Total Files after lapse (SS_) = 7
<007.ST_> Total Files after lapse (ST_) = 8
<007RC> STATUS - Total Files after lapse = 0

File Transfer Latency show the time consumed in the test overall operation.
File Transfer Success show the percent of success in the test file transfers.
Total Files counts the number of files in directory
Latest File Modification Time shows the most recent file time in directory
Oldest File Modification Time shows the oldest file time in directory
Total Files before lapse counts the number of files in directory before the specified lapse
Total Files after lapse counts the number of files in directory after the specified lapse
The parameters are:

 linux_metric_file_server.pl -host 1.1.1.1 -user user1 -pwd xxx [-port 22|...] [-proto sftp|...] [-action test] [-files 10|...] [-size 100000|...] [-v]
 linux_metric_file_server.pl -host 1.1.1.1 -user user1 -pwd xxx [-port 22|...] [-proto sftp|...] -action count [-remotedir /dir1/xx] [-v]
 linux_metric_file_server.pl -host 1.1.1.1 -user user1 -pwd xxx [-port 22|...] [-proto sftp|...] -action count [-remotedir /dir1/xx] [-lapse 3600] [-v]
 linux_metric_file_server.pl -host 1.1.1.1 -user user1 -pwd xxx [-port 22|...] [-proto sftp|...] -action count [-remotedir /dir1/xx] [-lapse 3600]  [-pattern a,b,c] [-v]
 linux_metric_file_server.pl -h  : Help

 -host       : File Server Host
 -port       : Port (default 22)
 -user       : Server User
 -pwd        : Server User Password
 -proto      : Protocol (default sftp)
 -action     : test|count
 -files      : Number of files used (tx/rx). Default is 10. (mode=test)
 -size       : Aggregated size. Default is 300KB. (mode=test)
 -remotedir  : Remote directory  (mode=count|test)
 -lapse      : Defines a time reference (tRef) = Tnow-lapse in mode=count.
 -pattern    : Text pattern (or patterns) for file classification in mode count
 -timeout    : Max. Timeout [Default 20 sg]
 -v/-verbose : Verbose output (debug)
 -h/-help    : Help
',
      );

?>
