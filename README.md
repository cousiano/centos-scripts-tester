centos-scripts-tester
=====================

bash scripts to test 'centos-scripts'
Note: This example use cygwin, but also work in an unix system. Just update the parameters section.

Prerequistes
============

- Install a fresh centos (in directory /opt/centos-tester, named centos)
  => Note: you should have the following path to your virtual machine /opt/centos-tester/centos/centos.vmx
- Get the centos-scripts
- Install prerequistes
- Shutdown computer

Execution
=========

```bash
  bash tester.bash
```

That will :
- create all the 'centos-scripts' vmware.
- launch them

And then?
=========
Now, execute your server installation script in each vmware:
```bash

  # First load eth1 (eth0 still have the template mac address).
  dhclient eth1
  
  # Then, execute scripts:
  cd /opt/centos-scripts
  bash setup.sh  # here choose your srv-xxx  
```
