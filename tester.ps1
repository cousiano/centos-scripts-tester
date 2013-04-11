# You must change the execution policy
#
# - Restricted - No scripts can be run. Windows PowerShell can be used only in interactive mode.
# - AllSigned - Only scripts signed by a trusted publisher can be run.
# - RemoteSigned - Downloaded scripts must be signed by a trusted publisher before they can be run.
# - Unrestricted - No restrictions; all Windows PowerShell scripts can be run.
#
# To assign a particular policy simply call Set-ExecutionPolicy followed by the appropriate policy name. For example, this command sets the execution policy to RemoteSigned:
#  Set-ExecutionPolicy RemoteSigned
#
# Note: To determine your current execution policy, you can run : Get-ExecutionPolicy
#

################################
# PARAMETERS
################################
$breakLine="`n"

$vmware_exe="C:/Program Files (x86)/VMware/VMware Player/vmplayer.exe"
$vmware_home="$HOME/Documents/Virtual Machines"
$vmware_template="centos"
$vmware_list="SCM/srv-scm","Production/srv-monitoring","Production/srv-redmine","Production/srv-intranet","Build/srv-build-linux","Build/srv-cit","Network/srv-mail","Network/srv-dhcp","Network/srv-dns","Network/srv-ldap","Other/srv-tomcat","Other/srv-ftp","Other/srv-samba"

################################
# PREREQUISTES
################################

$question  = "You must have the following prerequistes"+$breakLine
$question += " - Centos installed"+$breakLine
$question += " - Prerequistes scripts executed"+$breakLine
$question += $breakLine
$question += "Is everything ok ?"

$a = new-object -comobject wscript.shell 
$intAnswer = $a.popup($question, 0,"Prerequistes",4) 
If ($intAnswer -ne 6)
{     
  exit
}

################################
# SCRIPT
################################

echo "remove other Virtual Machines"
dir "$vmware_home" | where { ($_.name -ne "$vmware_template") -and ($_.extension -ne ".iso")}| Remove-Item -Recurse -force

echo "now duplicate vmware"
foreach ($item in $vmware_list)
{
  $srv_name=[System.IO.Path]::GetFileNameWithoutExtension("$item")
  echo "working with $item ($srv_name)"
  
  # duplicate item:
  Copy-Item "$vmware_home/$vmware_template" "$vmware_home/$item" -recurse
  
  # rename files:
  Get-ChildItem "$vmware_home/$item" | Rename-Item -NewName { $_.Name -replace "^$vmware_template+","$srv_name"}
    
  # replace $vmware_template by $item in configuration files:
  Get-Content "$vmware_home/$item/$srv_name.vmx" | %{$_ -replace "$vmware_template+","$srv_name"} | Set-Content "$vmware_home/$item/$srv_name.vmx.output"  
  Move-Item "$vmware_home/$item/$srv_name.vmx.output" "$vmware_home/$item/$srv_name.vmx" -force
  
  Get-Content "$vmware_home/$item/$srv_name.vmdk" | %{$_ -replace "$vmware_template+","$srv_name"} | Set-Content "$vmware_home/$item/$srv_name.vmdk.output"  
  Move-Item "$vmware_home/$item/$srv_name.vmdk.output" "$vmware_home/$item/$srv_name.vmdk" -force
  
  Get-Content "$vmware_home/$item/$srv_name.vmxf" | %{$_ -replace "$vmware_template+","$srv_name"} | Set-Content "$vmware_home/$item/$srv_name.vmxf.output"  
  Move-Item "$vmware_home/$item/$srv_name.vmxf.output" "$vmware_home/$item/$srv_name.vmxf" -force
  
  # correct vmx 'guestOS = "centos-64"'
  Get-Content "$vmware_home/$item/$srv_name.vmx" | %{$_ -replace "$srv_name-64+","centos"} | Set-Content "$vmware_home/$item/$srv_name.vmx.output"  
  Move-Item "$vmware_home/$item/$srv_name.vmx.output" "$vmware_home/$item/$srv_name.vmx" -force
  
  # now launch vmware:
  & $vmware_exe "$vmware_home/$item/$srv_name.vmx"
}