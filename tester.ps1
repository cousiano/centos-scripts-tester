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

$vmware_home="$HOME/Documents/Virtual Machines"
$vmware_template="centos"

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

