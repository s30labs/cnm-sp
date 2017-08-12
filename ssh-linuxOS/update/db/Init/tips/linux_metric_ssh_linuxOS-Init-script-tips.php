<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_ssh_linuxOS.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Este script permite obtener las siguientes métricas de un equipo Linux:

<001> Zombie Process <002> Process Uptime (min) <003> System uptime <004> Files opened by process <005> Total Inodes <006> Used Inodes <007> Free Inodes <008> Used Inodes (%) <009> Load 1m <010> Load 5m <011> Load 15m <012> CPU User <013> CPU Nice <014> CPU System <015> CPU IOwait <016> CPU Irq <017> CPU SoftIrq <018> CPU Interrupts <019> CPU Context Switches <020> Processes <021> Processes Run <022> Processes Blocked <023> Rx bytes <024> Rx packets <025> Rx errs <026> Rx drop <027> Rx fifo <028> Rx frame <029> Rx compressed <030> Rx multicast <031> Tx bytes <032> Tx packets <033> Tx errs <034> Tx drop <035> Tx fifo <036> Tx frame <037> Tx compressed <038> Tx multicast <039> Rx bits <040> Tx bits <041> operstate <042> mtu <043> Total 1K-blocks <044> Used <045> Available <046> Used (%)
 
Sus parámetros de ejecución son:

 linux_metric_ssh_linuxOS.pl -n 1.1.1.1 [-port 2322]
 linux_metric_ssh_linuxOS.pl -n 1.1.1.1 -user=aaa -pwd=bbb
 linux_metric_ssh_linuxOS.pl -n 1.1.1.1 -user=aaa -key_file=/etc/ssh/id_rsa
 linux_metric_ssh_linuxOS.pl -n 1.1.1.1 -user=aaa -key_file=1
 linux_metric_ssh_linuxOS.pl -h  : Ayuda

 -n          : IP remota
 -port       : Puerto
 -user       : Usuario
 -pwd        : Clave
 -passphrase : Passphrase SSH
 -key_file   : Fichero con la clave publica (Si vale 1 indica que ua el ficheo estandar de CNM)
 -v/-verbose : Muestra informacion extra(debug)
 -h/-help    : Ayuda
 -l          : Lista las metricas que obtiene
',
      );

?>
