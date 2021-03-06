#!/bin/bash

echo "CENTOS - TESTER"

################################
# PARAMETERS
################################
vmware_exe="/cygdrive/c/Program Files (x86)/VMware/VMware Player/vmplayer.exe"

vmware_home="/opt/script-tester"
vmware_template="CentOS 64-bit"
vmware_list=("SCM/srv-scm" "Production/srv-monitoring" "Production/srv-redmine" "Production/srv-intranet" "Build/srv-build-linux" "Build/srv-cit" "Network/srv-mail" "Network/srv-dhcp" "Network/srv-dns" "Network/srv-ldap" "Network/srv-vpn" "Other/srv-ftp" "Other/srv-tomcat" "Other/srv-samba" "Other/srv-nfs")

################################
# PREREQUISTES
################################

echo
echo "You must have the following prerequistes"
echo " - Centos installed"
echo " - Prerequistes scripts executed"
echo

# reminder for the user.
PS3="Is everything ok ? (1: yes/2: no) : "
options=("yes" "no")
select opt in "${options[@]}"
 do
  case $opt in
      "yes")
          break
          ;;
      "no")
          echo "exit script."
          echo "everything must be ok to continue...."
          exit
          ;;
      *) echo "invalid option $REPLY";;
  esac
done


################################
# FUNCTIONS
################################

function print_level1()
{
  local string=$1
  echo "$string"
}

function print_level2()
{
  local string=$1
  echo "  $string"
}

################################
# SCRIPT
################################

print_level1 "Remove other Virtual Machines"
find $vmware_home -maxdepth 1 -type d -not -path "$vmware_home" -not -path "$vmware_home/$vmware_template" -exec rm -rf {} \;

print_level1 "Now duplicate vmware"

for index in "${!vmware_list[@]}"; do
  vmware="${vmware_list[$index]}"  
  srv_categ=`dirname "$vmware"`
  srv_name=`basename "$vmware"`
  print_level1 "working with $item ($vmware : $srv_categ => $srv_name)"  
  
  # duplicate item:
  print_level2 "1- duplicate item"
  mkdir -p "$vmware_home/$srv_categ"
  cp -r "$vmware_home/$vmware_template/" "$vmware_home/$vmware/"
  
  # rename files:
  print_level2 "2- rename files '$vmware_template*' to '$srv_name'"
  find "$vmware_home/$vmware/" -name "$vmware_template*" -exec echo {} \; > /tmp/vmware_files
  while read line  
  do   
     name=$line
     newname=`echo $line | sed "s/$vmware_template/$srv_name/ig"`
     mv "$name" "$newname"
  done < /tmp/vmware_files
  
  # find "$vmware_home/$vmware/" -name "$vmware_template*" -exec mv -v "{}" "`echo {} | sed "s/$vmware_template/$srv_name/ig"`" \; 
  
  # replace '$vmware_template' by '$srv_name' in configuration files:
  print_level2 "3- replace '$vmware_template' by '$srv_name' in configuration files"
  find "$vmware_home/$vmware/" -name "$srv_name\.*" -exec sed -i "s/$vmware_template/$srv_name/ig" {} \;  
  
  # force vmware to generate a new mac address (remove lines that begin with...):
  print_level2 "4- force vmware to generate a new mac address"
  # sed -i '/^ethernet0.addressType/d' "$vmware_home/$vmware/$srv_name.vmx"
  # sed -i '/^uuid.location/d' "$vmware_home/$vmware/$srv_name.vmx"
  sed -i '/^uuid.bios/d' "$vmware_home/$vmware/$srv_name.vmx"
  # sed -i '/^ethernet0.generatedAddress/d' "$vmware_home/$vmware/$srv_name.vmx"
  # sed -i '/^ethernet0.generatedAddressOffset/d' "$vmware_home/$vmware/$srv_name.vmx"
  
  # now launch vmware:
  print_level2 "5- now launch vmware"
  cd "$vmware_home/$vmware"  
  "$vmware_exe" "$srv_name.vmx" &
  cd -
  
done

################################
# Help tool
################################

# This part ask if the user correctly execute the installation script.

for index in "${!vmware_list[@]}"; do
  vmware="${vmware_list[$index]}"  
  srv_categ=`dirname "$vmware"`
  srv_name=`basename "$vmware"`
  
  PS3="Is everything ok for the server $vmware? (1: yes) : "
  options=("yes")
  select opt in "${options[@]}"
   do
    case $opt in
        "yes")
            break
            ;;      
        *) echo "invalid option $REPLY";;
    esac
  done
  
done

exit;