centos-scripts-tester
=====================

bash scripts to test 'centos-scripts'<br>
Please read/update the parameters section.

Prerequistes
============

- Install a fresh centos (in directory /opt/script-tester, named CentOS 64-bit)
  => Note: you should have the following path to your virtual machine /opt/script-tester/CentOS 64-bit/CentOS 64-bit.vmx
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
