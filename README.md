centos-scripts-Tester
=====================

powershell scripts to test 'centos-scripts'

Prerequistes
============

- Install a fresh centos (in $HOME/Documents/Virtual Machines/centos, named centos)
- Get the centos-scripts
- Install prerequistes
- Shutdown computer

Note: Location in your $HOME/Documents/Virtual Machines directory.

Execution
=========

Execute tester.ps1.
That will :
- create all the 'centos-scripts' vmware.
- launch them

And then?
=========
Now, execute your server installation script:
```bash
  cd /opt/centos-scripts
  bash setup.sh  # here choose your srv-xxx  
```

