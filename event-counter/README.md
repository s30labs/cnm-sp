# event-counter
CNMSP that contains a script that support metrics that count the number of events under certain circunstances.

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

 -host       : Host al que se asocia la metrica
 -app        : ID de la app.
 -syslog     : IP del equipo que envia por syslog.
 -trap       : IP|id_dev|name.domain del equipo que envia el trap.
 -lapse      : Intervalo seleccionado referenciado desde el instante actual (now-lapse). Se especifica en minutos. Por defecto 60.
 -pattern    : Patron de busqueda. Por defecto se cuentan todos los eventos.
 -v/-verbose : Verbose output (debug)
 -h/-help    : Help

```

## Output 

```
 <001> Event Counter = 6
```

