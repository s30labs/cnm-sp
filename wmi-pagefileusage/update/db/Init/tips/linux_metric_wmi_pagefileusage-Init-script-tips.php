<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_wmi_pagefileusage.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Obtiene el uso del fichero de paginacion de WIndows. Concreatamente los valores de AllocatedBaseSize (MB, CurrentUsage (MB) y PeakUsage (MB). Un ejemplo de ejecuci√≥n es:
cnm@cnm:/opt/cnm/xagent/base# ./linux_metric_wmi_pagefileusage.pl -h
linux_metric_wmi_pagefileusage.pl 1.0

linux_metric_wmi_pagefileusage.pl -n IP -u user -p pwd [-d domain] [-i Name]
linux_metric_wmi_pagefileusage.pl -n IP -u domain/user -p pwd [-i Name]
linux_metric_wmi_pagefileusage.pl -h  : Ayuda

-n    IP remota
-u    user
-p    pwd
-d    Dominio
-i    Index Propiedad para indexar las instancias. Por defecto es Name.
-f    Filtro sobre la consulta WSQL aplicado sobre el indice
-h    Ayuda

Si no se especifican Index y Filtro. Devuelve todas las instancias:
<AllocatedBaseSize.C> AllocatedBaseSize = 512
<AllocatedBaseSize.E> AllocatedBaseSize = 13312
<CurrentUsage.C> CurrentUsage = 134
<CurrentUsage.E> CurrentUsage = 968
<PeakUsage.C> PeakUsage = 235
<PeakUsage.E> PeakUsage = 2260
Si se especifican (-i Name -f "C:\pagefile.sys"), devuelve s√lo la especificada:
<AllocatedBaseSize.C> AllocatedBaseSize = 512
<CurrentUsage.C> CurrentUsage = 134
<PeakUsage.C> PeakUsage = 235

',
      );

?>
