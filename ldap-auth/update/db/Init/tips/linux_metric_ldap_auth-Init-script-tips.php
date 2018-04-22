<?php
      $TIPS[]=array(
         'id_ref' => 'linux_metric_ldap_auth.pl',  'tip_type' => 'script', 'url' => '',
         'date' => '',     'tip_class' => 1, 'name' => 'Descripcion',
         'descr' => 'Checks for LDAP Authentication

The parameters are:

 linux_metric_ldap_auth.pl -host 1.1.1.1 -user user1 -pwd mysecret
 linux_metric_ldap_auth.pl -host 1.1.1.1 [-port 1111] -user user1 -pwd mysecret -version 1
 linux_metric_ldap_auth.pl -host 1.1.1.1 [-port 1111] -secure -user user1 -pwd mysecret
 linux_metric_ldap_auth.pl -h  : Help

 -host       : Database Server Host
 -port       : Port (default 389)
 -user       : LDAP User
 -pwd        : LDAP User Password
 -version    : LDAP Version (default 3)
 -secure     : LDAP/LDAPS
 -v/-verbose : Verbose output (debug)
 -h/-help    : Help
',
      );

?>
