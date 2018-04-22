# file-server 
Contains a script for checking the upload/download of files to a server (currently SFTP). It returns the percentage of success (100% means no failure) and the time employed in the operation.

## Contains
- [x] Script for metric
- [ ] Script for application 
- [ ] Metric/s
- [ ] Application/s
- [ ] Monitors

## Script Info
```
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

```

## Output 

```
 <001> File Transfer Latency = 0.008458
 <002> File Transfer Success = 100
```

