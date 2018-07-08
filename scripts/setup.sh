#!/bin/bash

# Generated by POWSCRIPT (https://github.com/coderofsalvation/powscript)
#
# Unless you like pain: edit the .pow sourcefiles instead of this file

# powscript general settings
set -e                                # halt on error
set +m                                #
SHELL="$(echo $0)"                    # shellname
shopt -s lastpipe                     # flexible while loops (maintain scope)
shopt -s extglob                      # regular expressions
path="$(pwd)"
if [[ "$BASH_SOURCE" == "$0"  ]];then #
  SHELLNAME="$(basename $SHELL)"      # shellname without path
  selfpath="$( dirname "$(readlink -f "$0")" )"
  tmpfile="/tmp/$(basename $0).tmp.$(whoami)"
else
  selfpath="$path"
  tmpfile="/tmp/.dot.tmp.$(whoami)"
fi
#
# generated by powscript (https://github.com/coderofsalvation/powscript)
#

map () 
{ 
    local arr="$1";
    shift;
    local func="$1";
    shift;
    eval "for i in \"\${!$arr[@]}\"; do $func \"\$@\" \"\$i\" \"\${$arr[\$i]}\"; done"
}

on () 
{ 
    func="$1";
    shift;
    for sig in "$@";
    do
        trap "$func $sig" "$sig";
    done
}



INVALID_ANS="Invalid answer"

print_kv(){
  local k="${1}"
  local v="${2}"
  echo key="$k" val="$v"
}

print_map(){
  local m="${1}"
  map "$m" print_kv
}

ask_ans(){
  local ret="${1}"
  local msg="${2}"
  if [[ $# -le 1 ]]; then
    echo "Too few parameters"
    exit
  fi
  echo -ne "$msg"" : "
  read ans
  eval "$ret=$ans"
}

ask_yn(){
  local ret="${1}"
  local msg="${2}"
  if [[ $# -le 1 ]]; then
    echo "Too few parameters"
    exit
  fi
  while true; do
    echo -ne "$msg"" y/n : "
    read ans
    if [[ "$ans" == "y" ]]; then
      eval "$ret=true"
      break
    else
      if [[ "$ans" == "n" ]]; then
        eval "$ret=false"
        break
      else
        echo -e "$INVALID_ANS"
      fi
    fi
  done
}

ask_if_correct(){
  local ret="${1}"
  ask_yn "$ret" "Is this correct?"
}

default_wait=1
wait_and_clear(){
  local v="${1}"
  if [[ $# == 0 ]]; then
    sleep "$default_wait"
  else
    sleep "$v"
  fi
  clear
}

tell_press_enter(){
  echo "Press enter to continue"
  read
}

install_with_retries(){
  local package_name="${1}"
  local mount_path="${2}"
  if [[ $# == 0 ]]; then
    echo "Too few parameters"
    exit
  fi
  retries=5
  retries_left="$retries"
  while true; do
    echo "Installing ""$package_name"" package"
    arch-chroot "$mount_path" pacman --noconfirm -S "$package_name"
    if [[ $? == 0 ]]; then
      break
    else
      retries_left="${[$retries_left - 1]}"
    fi
    if [[ "$retries_left" == 0 ]]; then
      echo "Package install failed ""$retries"" times"
      ask_yn change_name "Do you want to change package name before continuing retry?"
      if [[ "$change_name" ]]; then
        ask_new_name_end=false
        while [[ ! "$ask_new_name_end" ]]; do
          ask_ans package_name "Please enter new package name : "
          ask_if_correct ask_new_name_end
        done
      fi
      retries_left="$retries"
    fi
  done
}



NO_COMMAND="Command not found"

cat <<STAGEEOF
Stages:
    update time
    choose editor
    configure mirrorlist
    choose system disk
    setup partitions
    set hostname
    set locale
    update package database
    install system
    setup GRUB
    setup GRUB config
    intall GRUB
    install SSH
    setup SSH
    generate saltstack execution script
    generate setup note
    add user
    install saltstack             (optional)
      |-> copy saltstack files          (optional)
      |-> execute salt for final setup  (optional)
    close all disks               (optional)
    restart                       (optional)

STAGEEOF

tell_press_enter
clear

echo "Updating time"
timedatectl set-ntp true

echo ""
echo -n "Current time : "
date

wait_and_clear 5

declare -A config

echo "Choose editor"
echo ""

end=false
while [[ "$end" == false ]]; do
  ask_ans config["editor"] "Please specifiy an editor to use"
  if [[ -x "$(command -v "${config["editor"]}")" ]]; then
    echo Editor selected : "${config["editor"]}"
    ask_if_correct end
  else
    echo -e "$NO_COMMAND"
  fi
done

clear

echo "Configure mirrorlist"
echo ""

tell_press_enter

mirrorlist_path="/etc/pacman.d/mirrorlist"
end=false
while [[ "$end" == false ]]; do
  "${config["editor"]}" $mirrorlist_path
  clear
  ask_yn end "Finished editing"
done

clear

echo "Choose system partition"
echo ""

end=false
while [[ "$end" == false ]]; do
  ask_ans config["sys_disk"] "Please specify the system disk"
  if [[ -b "${config["sys_disk"]}" ]]; then
    echo "System parition picked :" ""${config["sys_disk"]}""
    ask_if_correct end
  else
    echo "Disk does not exist"
  fi
done

clear

efi_firmware_path="/sys/firmware/efi"

if [[ -e "$efi_firmware_path" ]]; then
  echo "System is in UEFI mode"
  config["efi_mode"]=true
else
  echo "System is in BIOS mode"
  config["efi_mode"]=false
fi

wait_and_clear 1

echo "Wiping paritioning info"
dd if=/dev/zero of="${config["sys_disk"]}" bs=512 count=2 &>/dev/null

wait_and_clear 2

config["sys_disk_size_bytes"]="$(fdisk -l "$USB_KEY" | head -n 1 | sed "s|.*, \(.*\) bytes.*||")"
config["sys_disk_size_KiB"]}"
config["sys_disk_size_MiB"]}"
config["sys_disk_size_GiB"]}"

if "${config["efi_mode"]}" == true
  echo "Creating GPT partition table"
  parted "${config["sys_disk"]}" mklabel gpt &>/dev/null
  echo "Calculating partition sizes"
  # use MiB for rough estimation
  # calculate % of 200 MiB size
  esp_part_size=200
  esp_part_perc="${[($esp_part_size * 100) / ${config["sys_disk_size_MiB"]}"
  esp_part_beg_perc=0
  esp_part_end_perc="$esp_part_perc"
  #
  boot_part_size=200
  boot_part_perc="${[($esp_part_end_perc * 100) / ${config["sys_disk_size_MiB"]}"
  boot_part_beg_perc="$esp_part_end_perc"
  boot_part_end_perc="${[$boot_part_beg_perc + $boot_part_perc]}"
  #
  root_part_beg_perc="$boot_part_end_perc"
  root_part_end_perc=100
  #
  echo "Partitioning"
  parted -a optimal "${config["sys_disk"]}" mkpart primary fat32 \
    "$esp_part_beg_perc%"  "$esp_part_end_perc%"  &>/dev/null
  parted -a optimal "${config["sys_disk"]}" mkpart primary       \
    "$boot_part_beg_perc%" "$boot_part_end_perc%" &>/dev/null
  parted -a optimal "${config["sys_disk"]}" mkpart primary       \
    "$root_part_beg_perc%" "$root_part_end_perc%" &>/dev/null
  #
  parted "${config["sys_disk"]}" set 1 boot on &>/dev/null
  #
  config["sys_disk_esp"]}"1
  #
  echo "Formatting ESP partition"
  mkfs.fat -F32 "${config["sys_disk_esp"]}"
  #
  config["sys_disk_esp_uuid"]}" | sed -n "s@\(.*\)UUID=\"\(.*\)\" TYPE\(.*\)@\2@p")
  config["sys_disk_boot"]}"2
  fi
else
  echo "Creating MBR partition table"
  parted "${config["sys_disk"]}" mklabel msdos &>/dev/null
  #
  echo "Partitioning"
  boot_part_size=200
  boot_part_perc="${[($esp_part_end_perc * 100) / ${config["sys_disk_size_MiB"]}"
  boot_part_beg_perc=0
  boot_part_end_perc="$boot_part_perc"
  #
  parted -a optimal "${config["sys_disk"]}" mkpart primary \
    "$boot_part_start_perc%"  "$boot_part_end_perc%" &>/dev/null
  parted -a optimal "${config["sys_disk"]}" mkpart primary \
    "$boot_part_end_perc%" "100%" &>/dev/null
  #
  parted "${config["sys_disk"]}" set 1 boot on &>/dev/null
  #
  config["sys_disk_boot"]}"1

wait_and_clear 2

print_map config

# wait for all async child processes (because "await ... then" is used in powscript)
[[ $ASYNC == 1 ]] && wait


# cleanup tmp files
if ls /tmp/$(basename $0).tmp.darren* &>/dev/null; then
  for f in /tmp/$(basename $0).tmp.darren*; do rm $f; done
fi

exit 0

