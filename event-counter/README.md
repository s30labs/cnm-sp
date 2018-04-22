# event-counter
Contains a script for checking the number of events registered under defined conditions.

## Contains
- [x] Script for metric
- [ ] Script for application 
- [ ] Metric/s
- [ ] Application/s
- [ ] Monitors

## Script Info
```
 linux_metric_event_counter.pl -app 333333000006 -lapse 120 -pattern '"MDW_Alert_Type":"MAT"' [-v]
 linux_metric_event_counter.pl -syslog ip -lapse 120 -pattern 'FTP.Login.Failed' [-v]
 linux_metric_event_counter.pl -trap ip|id_dev|name.domain -lapse 120 -pattern 'FTP.Login.Failed' [-v]
 linux_metric_event_counter.pl -h  : Help

 -host       : Metric associated Host
 -app        : App ID.
 -syslog     : IP address of syslog sender.
 -trap       : IP|id_dev|name.domain of trap sender.
 -lapse      : Time window (now-lapse). Defined in minutes (60 by defaault).
 -pattern    : Search pattern (all by default).
 -v/-verbose : Verbose output (debug)
 -h/-help    : Help

```

## Output 

```
 <001> Event Counter = 6
```

