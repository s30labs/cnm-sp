# ldap-auth
Contains a script for checking the LDAP/LDAPS authentication process.
Returns the status and the time latency.

## Contains
- [x] Script for metric
- [ ] Script for application 
- [ ] Metric/s
- [ ] Application/s
- [ ] Monitors

## Script Info
```
 linux_metric_ldap_auth.pl -host 1.1.1.1 -user user1 -pwd mysecret
 linux_metric_ldap_auth.pl -host 1.1.1.1 [-port 1111] -user user1 -pwd mysecret -version 1
 linux_metric_ldap_auth.pl -host 1.1.1.1 [-port 1111] -secure -user user1 -pwd mysecret
 linux_metric_ldap_auth.pl -h  : Help

 -host       : LDAP/LDAPS Server Host
 -port       : Port (default 389)
 -user       : LDAP User
 -pwd        : LDAP User Password
 -version    : LDAP Version (default 3)
 -secure     : LDAP/LDAPS
 -v/-verbose : Verbose output (debug)
 -h/-help    : Help

```

## Output 

```
 <001> LDAP Auth Latency = 0.008458
 <002> LDAP Auth Status = 0
```

