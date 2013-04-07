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
$vmware_list="srv-build-linux","srv-cit"

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
  echo "working with $item"
  
  # duplicate item:
  Copy-Item "$vmware_home/$vmware_template" "$vmware_home/$item" -recurse
  
  # rename files:
  Get-ChildItem "$vmware_home/$item" | Rename-Item -NewName { $_.Name -replace "^$vmware_template+","$item"}
    
  # replace $vmware_template by $item in configuration files:
  Get-Content "$vmware_home/$item/$item.vmx" | %{$_ -replace "$vmware_template+","$item"} | Set-Content "$vmware_home/$item/$item.vmx.output"  
  Move-Item "$vmware_home/$item/$item.vmx.output" "$vmware_home/$item/$item.vmx" -force
  
  Get-Content "$vmware_home/$item/$item.vmdk" | %{$_ -replace "$vmware_template+","$item"} | Set-Content "$vmware_home/$item/$item.vmdk.output"  
  Move-Item "$vmware_home/$item/$item.vmdk.output" "$vmware_home/$item/$item.vmdk" -force
  
  Get-Content "$vmware_home/$item/$item.vmxf" | %{$_ -replace "$vmware_template+","$item"} | Set-Content "$vmware_home/$item/$item.vmxf.output"  
  Move-Item "$vmware_home/$item/$item.vmxf.output" "$vmware_home/$item/$item.vmxf" -force
  
  # now launch vmware:
  & $vmware_exe "$vmware_home/$item/$item.vmx"
}