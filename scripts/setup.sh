#!/bin/bash



map() {
{
local A f;
[ $# -ge 1 ] && A="${1}"
[ $# -ge 2 ] && f="${2}"
}
shift 2
eval "{
local k; for k in \"\${!$A[@]}\"; do
local v=\"\${$A[\"\${k}\"]}\";
$f \"\${@}\" \"\${k}\" \"\${v}\"
done
}"
}

mappipe() {
{
local f;
[ $# -ge 1 ] && f="${1}"
}
shift
while read -r line; do
"${f}" "${@}" "${line}"
done
}

curry() {
{
local out f x;
[ $# -ge 1 ] && out="${1}"
[ $# -ge 2 ] && f="${2}"
[ $# -ge 3 ] && x="${3}"
}
eval "{
$out() {
$f '$x' \"\${@}\"
}
}"
}

keys() {
{
local x y;
[ $# -ge 1 ] && x="${1}"
[ $# -ge 2 ] && y="${2}"
}
echo "${x}"
}

values() {
{
local x y;
[ $# -ge 1 ] && x="${1}"
[ $# -ge 2 ] && y="${2}"
}
echo "${y}"
}

set?() {
{
local s;
[ $# -ge 1 ] && s="${1}"
}
eval "{
return \"\$(( \${$s+-1}+1 ))\"
}"
}

unset?() {
{
local s;
[ $# -ge 1 ] && s="${1}"
}
eval "{
return \"\$(( \${$s+1}+0 ))\"
}"
}

empty?() {
{
local s;
[ $# -ge 1 ] && s="${1}"
}
eval "{
return \"\$(( \${$s:+1}+0 ))\"
}"
}

nonempty?() {
{
local s;
[ $# -ge 1 ] && s="${1}"
}
eval "{
return \"\$(( \${$s:+-1}+1 ))\"
}"
}

bool() {
{
local int;
[ $# -ge 1 ] && int="${1}"
}
return "${int}"
}

filter() {
{
local A p;
[ $# -ge 1 ] && A="${1}"
[ $# -ge 2 ] && p="${2}"
}
shift 2
eval "{
local k; for k in \"\${!$A[@]}\"; do
local v=\"\${$A[\"\${k}\"]}\";
if $p \"\${@}\" \"\${k}\" \"\${v}\"; then
echo \"\${v}\"
fi
done
}"
}

compose() {
{
local fg f g;
[ $# -ge 1 ] && fg="${1}"
[ $# -ge 2 ] && f="${2}"
[ $# -ge 3 ] && g="${3}"
}
eval "{
$fg() {
$f \"\$( $g \"\${@}\" )\"
}
}"
}

pick() {
{
local A k;
[ $# -ge 1 ] && A="${1}"
[ $# -ge 2 ] && k="${2}"
}
if [ -z "${k}" ]; then
return 1
fi
eval "{
local output=\"\${$A[$k]}\"
}"
if [ -n "${output}" ]; then
echo "${output}"
fi
}

first() {
{
local A;
[ $# -ge 1 ] && A="${1}"
}
if unset? A; then
return 1
fi
eval "{
echo \"\${$A[0]}\"
}"
}

last() {
{
local A;
[ $# -ge 1 ] && A="${1}"
}
if unset? A; then
return 1
fi
eval "{
echo \"\${$A[-1]}\"
}"
}

require_env() {
{
local var;
[ $# -ge 1 ] && var="${1}"
}
eval "{
pass \"\${$var?\"The variable $var is unset. Exitting.\"}\"
}"
}

ismap?() {
{
local x;
[ $# -ge 1 ] && x="${1}"
}
local result k1=__ismap_dummy1 k2=__ismap_dummy2
if empty? x; then
return 1
fi
eval "{
local $k1=0 $k2=0
local v
[ \"\$(( \${$x[$k1]+-1}+1 ))\" = 0 ] && v=\"\${$x[$k1]}\" 
$x[$k1]=a 
$x[$k2]=b 
if [ \"\${$x[$k1]}\" = a ]; then
unset $x[$k1]
unset $x[$k2]
return 0
else
[ \"\$(( \${v+-1}+1 ))\" = 0 ] && $x=\"\${v}\" || unset $x
return 1
fi
}"
}

copy_map() {
{
local __A __B;
[ $# -ge 1 ] && __A="${1}"
[ $# -ge 2 ] && __B="${2}"
}
if ! ismap? "${__A}"; then
echo 'ERROR: in copy_map: '"${__A}"' is not a map'
return 1
fi
if ! ismap? "${__B}"; then
echo 'ERROR: in copy_map: '"${__B}"' is not a map'
return 1
fi
eval "{
local __k; for __k in \"\${!$__A[@]}\"; do
local __v=\"\${$__A[\"\${__k}\"]}\";
$__B[\"\${__k}\"]=\"\${__v}\" 
done
}"
}

copy_array() {
{
local __A __B;
[ $# -ge 1 ] && __A="${1}"
[ $# -ge 2 ] && __B="${2}"
}
eval "{
local __k; for __k in \"\${!$__A[@]}\"; do
local __v=\"\${$__A[\"\${__k}\"]}\";
if ! [[ \"\${__k}\" =$ ^[1-9]+\$  ]]; then
echo 'ERROR: not a valid array key: '\"\${__k}\"''
return 1
fi
$__B[\"\${__k}\"]=\"\${__v}\" 
done
}"
}

clear_array() {
{
local __A;
[ $# -ge 1 ] && __A="${1}"
}
eval "{
local __k; for __k in \"\${!$__A[@]}\"; do
unset $__A[\"\${__k}\"]
done
}"
}

NL='
' 

pass() {
true
}






INVALID_ANS='Invalid answer' 

print_kv() {
{
local k v;
[ $# -ge 1 ] && k="${1}"
[ $# -ge 2 ] && v="${2}"
}
echo "${k}" '->' "${v}"
}

print_map() {
{
local m;
[ $# -ge 1 ] && m="${1}"
}
map "${m}" print_kv
}

div_rup() {
{
local a b;
[ $# -ge 1 ] && a="${1}"
[ $# -ge 2 ] && b="${2}"
}
echo $(( ( ( ${a:-0}+${b:-0}-1 )/${b:-0} ) ))
}


ask_ans() {
{
local ret msg;
[ $# -ge 1 ] && ret="${1}"
[ $# -ge 2 ] && msg="${2}"
}
echo -ne "${msg}"' : '
read ans
eval ''"${ret}"'='"${ans}"''
}

ask_yn() {
{
local ret msg;
[ $# -ge 1 ] && ret="${1}"
[ $# -ge 2 ] && msg="${2}"
}
while true; do
echo -ne "${msg}"' y/n : '
read ans
if [ "${ans}" = 'y' ]; then
eval ''"${ret}"'=true'
break
else
if [ "${ans}" = 'n' ]; then
eval ''"${ret}"'=false'
break
else
echo -e "${INVALID_ANS}"
fi
fi
done
}

ask_if_correct() {
{
local ret;
[ $# -ge 1 ] && ret="${1}"
}
ask_yn "${ret}" 'Is this correct?'
}

default_wait=1 
wait_and_clear() {
{
local v;
[ $# -ge 1 ] && v="${1}"
}
if [ $# = 0 ]; then
sleep "${default_wait}"
else
sleep "${v}"
fi
clear
}

tell_press_enter() {
echo 'Press enter to continue'
read
}

install_with_retries() {
{
local package_name;
[ $# -ge 1 ] && package_name="${1}"
}
if [ $# = 0 ]; then
echo 'Too few parameters'
exit
fi
retries=5 
retries_left="${retries}" 
while true; do
echo 'Installing '''"${package_name}"''' package'
arch-chroot "${config['mount_path']}" pacman --noconfirm -S "${package_name}"
if [ $? = 0 ]; then
break
else
retries_left=$["${retries_left}" 1 ]
fi
if [ "${retries_left}" = 0 ]; then
echo 'Package install failed '''"${retries}"''' times'
ask_yn change_name 'Do you want to change package name before continuing retry?'
if "${change_name}"; then
ask_new_name_end=false 
while ! "${ask_new_name_end}"; do
ask_ans package_name 'Please enter new package name : '
ask_if_correct ask_new_name_end
done
fi
retries_left="${retries}" 
fi
done
}


set +e

NO_COMMAND='Command not found' 


echo 'Stages:'
echo '    update time'
echo '    choose editor'
echo '    configure mirrorlist'
echo '    choose system disk'
echo '    setup partitions'
echo '    set hostname'
echo '    set locale'
echo '    update package database'
echo '    install system'
echo '    setup GRUB'
echo '    setup GRUB config'
echo '    intall GRUB'
echo '    generate saltstack execution script'
echo '    generate setup note'
echo '    add user'
echo '    install SSH'
echo '    setup SSH server'
echo '    setup SSH keys'
echo '    enable DHCP'
echo '    install saltstack'
echo '    copy saltstack files'
echo '    close all disks                     (optional)'
echo '    restart                             (optional)'

tell_press_enter
clear


echo 'Updating time'
timedatectl set-ntp true

echo ''
echo -n 'Current time : '
date

wait_and_clear 5

declare -A config 


echo 'Choose editor'
echo ''

end=false 
while ! "${end}"; do
ask_ans config['editor'] 'Please specifiy an editor to use'
if [ -x "$( command -v "${config['editor']}" )" ]; then
echo Editor selected : "${config['editor']}"
ask_if_correct end
else
echo -e "${NO_COMMAND}"
fi
done

clear


echo 'Configure mirrorlist'
echo ''

tell_press_enter

mirrorlist_path='/etc/pacman.d/mirrorlist' 
end=false 
while ! "${end}"; do
"${config['editor']}" "${mirrorlist_path}"
clear
ask_yn end 'Finished editing'
done

clear


echo 'Choose system disk'
echo ''

end=false 
while ! "${end}"; do
ask_ans config['sys_disk'] 'Please specify the system disk'
if [ -b "${config['sys_disk']}" ]; then
echo 'System parition picked :' "${config['sys_disk']}"
ask_if_correct end
else
echo 'Disk does not exist'
fi
done

clear


efi_firmware_path='/sys/firmware/efi' 

if [ -e "${efi_firmware_path}" ]; then
echo 'System is in UEFI mode'
config['efi_mode']=true 
else
echo 'System is in BIOS mode'
config['efi_mode']=false 
fi

wait_and_clear 1

echo 'Wiping parition table'
dd if=/dev/zero of="${config['sys_disk']}" bs=512 count=2 &>/dev/null

wait_and_clear 2

config['sys_disk_size_bytes']="$( fdisk -l "${config['sys_disk']}" | head -n 1 | sed 's|.*, \(.*\) bytes.*|\1|' )" 
config['sys_disk_size_KiB']=$(( ( "${config['sys_disk_size_bytes']}"/1024 ) )) 
config['sys_disk_size_MiB']=$(( ( "${config['sys_disk_size_KiB']}"/1024 ) )) 
config['sys_disk_size_GiB']=$(( ( "${config['sys_disk_size_MiB']}"/1024 ) )) 

if "${config['efi_mode']}"; then
echo 'Creating GPT partition table'
parted -s "${config['sys_disk']}" mklabel gpt &>/dev/null
echo 'Calculating partition sizes'
esp_part_size=200 
esp_part_perc="$( div_rup '('"${esp_part_size}"' * 100)' "${config['sys_disk_size_MiB']}" )" 
esp_part_beg_perc=0 
esp_part_end_perc="${esp_part_perc}" 
boot_part_size=200 
boot_part_perc="$( div_rup '('"${esp_part_end_perc}"' * 100)' "${config['sys_disk_size_MiB']}" )" 
boot_part_beg_perc="${esp_part_end_perc}" 
boot_part_end_perc=$(( ( ${boot_part_beg_perc:-0}+${boot_part_perc:-0} ) )) 
root_part_beg_perc="${boot_part_end_perc}" 
root_part_end_perc=100 
echo 'Partitioning'
parted -s -a optimal "${config['sys_disk']}" mkpart primary fat32 ''"${esp_part_beg_perc}"'%' ''"${esp_part_end_perc}"'%' &>/dev/null
parted -s -a optimal "${config['sys_disk']}" mkpart primary ''"${boot_part_beg_perc}"'%' ''"${boot_part_end_perc}"'%' &>/dev/null
parted -s -a optimal "${config['sys_disk']}" mkpart primary ''"${root_part_beg_perc}"'%' ''"${root_part_end_perc}"'%' &>/dev/null
parted -s "${config['sys_disk']}" set 1 boot on &>/dev/null
config['sys_part_esp']="${config['sys_disk']}"1 
config['sys_part_boot']="${config['sys_disk']}"2 
config['sys_part_root']="${config['sys_disk']}"3 
echo 'Formatting ESP partition'
mkfs.fat -F32 "${config['sys_disk_esp']}"
config['sys_part_esp_uuid']="$( blkid "${config['sys_disk_esp']}" | sed -n 's@\(.*\)UUID=\"\(.*\)\" TYPE\(.*\)@\2@p' )" 
else
echo 'Creating MBR partition table'
parted -s "${config['sys_disk']}" mklabel msdos &>/dev/null
echo 'Partitioning'
boot_part_size=200 
boot_part_perc="$( div_rup '('"${boot_part_size}"' * 100)' "${config['sys_disk_size_MiB']}" )" 
boot_part_beg_perc=0 
boot_part_end_perc="${boot_part_perc}" 
root_part_beg_perc="${boot_part_end_perc}" 
root_part_end_perc=100 
parted -s -a optimal "${config['sys_disk']}" mkpart primary ''"${boot_part_beg_perc}"'%' ''"${boot_part_end_perc}"'%' &>/dev/null
parted -s -a optimal "${config['sys_disk']}" mkpart primary ''"${root_part_beg_perc}"'%' ''"${root_part_end_perc}"'%' &>/dev/null
parted -s "${config['sys_disk']}" set 1 boot on &>/dev/null
config['sys_part_boot']="${config['sys_disk']}"1 
config['sys_part_root']="${config['sys_disk']}"2 
fi

wait_and_clear 2


config['mount_path']='/mnt' 

echo 'Formatting root partition'
mkfs.ext4 -F "${config['sys_part_root']}"

wait_and_clear 2

echo 'Mounting system partition'
mount "${config['sys_part_root']}" "${config['mount_path']}"

echo 'Creating boot directory'
mkdir -p "${config['mount_path']}"/boot

wait_and_clear 2

echo 'Formatting boot partition'
mkfs.ext4 -F "${config['sys_part_boot']}"

wait_and_clear 2

echo 'Mounting boot partition'
mount "${config['sys_part_boot']}" "${config['mount_path']}"/boot

wait_and_clear 2


while true; do
echo 'Installing base system(base base-devel)'
pacstrap /mnt base base-devel
if [ $? = 0 ]; then
break
else
:
fi
done

clear

echo 'Generating fstab'
mkdir -p "${config['mount_path']}"/etc
genfstab -U "${config['mount_path']}" >> "${config['mount_path']}"/etc/fstab

wait_and_clear 2


end=false 
while ! "${end}"; do
ask_ans config['host_name'] 'Please enter hostname'
echo 'You entered : ' "${config['host_name']}"
ask_if_correct end
done

echo "${config['host_name']}" > "${config['mount_path']}"/etc/hostname

wait_and_clear 2

echo 'Setting locale'
sed -i 's@#en_US.UTF-8 UTF-8@en_US.UTF-8 UTF-8@g' "${config['mount_path']}"/etc/locale.gen
echo 'LANG=en_US.UTF-8' > "${config['mount_path']}"/etc/locale.conf
arch-chroot "${config['mount_path']}" locale-gen

wait_and_clear 2


while true; do
echo 'Updating package database'
arch-chroot "${config['mount_path']}" pacman --noconfirm -Sy
if [ $? = 0 ]; then
break
else
:
fi
done


while true; do
echo 'Installing prerequisites for wifi-menu'
arch-chroot "${config['mount_path']}" pacman --noconfirm -S dialog wpa_supplicant
if [ $? = 0 ]; then
break
else
:
fi
done

clear

while true; do
echo 'Setting root password'
arch-chroot "${config['mount_path']}" passwd
if [ $? = 0 ]; then
break
else
:
fi
done

clear


install_with_retries 'grub'

if "${config['efi_mode']}"; then
install_with_retries 'efibootmgr'
install_with_retries 'efitools'
fi

clear


echo 'Install grub onto system disk'
if "${config['efi_mode']}"; then
echo 'Reset ESP directory'
rm -rf "${config['mount_path']}"/boot/efi
mkdir -p "${config['mount_path']}"/boot/efi
echo 'Mounting ESP partition'
mount "${config['sys_part_esp']}" "${config['mount_path']}"/boot/efi
arch-chroot "${config['mount_path']}" grub-install --target'='x86_64-efi --efi-directory'='/boot/efi --bootloader-id'='grub
else
arch-chroot "${config['mount_path']}" grub-install --target'='i386-pc --boot-directory'='/boot "${config['sys_disk']}"
fi

echo 'Generating grub configuration file'
arch-chroot "${config['mount_path']}" grub-mkconfig -o /boot/grub/grub.cfg

wait_and_clear 2


echo 'Setting up files in /root directory'
config['lssh_dir_name']='lssh_pack' 
config['lssh_dir_path']="${config['mount_path']}"/root/"${config['lssh_dir_name']}" 
mkdir -p "${config['lssh_dir_path']}"


echo 'Copying useradd helper scripts'
config['useradd_helper1_name']='useradd_helper_as_powerful.sh' 
config['useradd_helper1_path']="${config['lssh_dir_path']}"/"${config['useradd_helper1_name']}" 
cp "${config['useradd_helper1_name']}" "${config['useradd_helper1_path']}"
chmod u=rx "${config['useradd_helper1_path']}"
chmod g=rx "${config['useradd_helper1_path']}"
chmod o='' "${config['useradd_helper1_path']}"

config['useradd_helper2_name']='useradd_helper_restricted.sh' 
config['useradd_helper2_path']="${config['lssh_dir_path']}"/"${config['useradd_helper2_name']}" 
cp "${config['useradd_helper2_name']}" "${config['useradd_helper2_path']}"
chmod u=rx "${config['useradd_helper2_path']}"
chmod g=rx "${config['useradd_helper2_path']}"
chmod o='' "${config['useradd_helper2_path']}"


echo 'Copying helper for adding SSH keys over'
config['add_ssh_keys_helper_name']='add_ssh_keys.sh' 
config['add_ssh_keys_helper_path']="${config['lssh_dir_path']}"/"${config['add_ssh_keys_helper_name']}" 
cp "${config['add_ssh_keys_helper_name']}" "${config['add_ssh_keys_helper_path']}"
chmod u=rx "${config['add_ssh_keys_helper_path']}"
chmod g=rx "${config['add_ssh_keys_helper_path']}"
chmod o='' "${config['add_ssh_keys_helper_path']}"

echo 'User setup'
echo ''

while true; do
ask_end=false 
while ! "${ask_end}"; do
ask_ans config['user_name'] 'Please enter the main user name(this will be used for SSH access)'
echo 'You entered :' "${config['user_name']}"
ask_if_correct ask_end
done
echo 'Adding user'
arch-chroot "${config['mount_path']}" useradd -m "${config['user_name']}" -G users,wheel,rfkill
if [ $? = 0 ]; then
break
else
echo 'Failed to add user'
echo 'Please check whether the user name is correctly specified and if acceptable by the system'
tell_press_enter
fi
done

while true; do
echo 'Setting password for user :' "${config['user_name']}"
arch-chroot "${config['mount_path']}" passwd "${config['user_name']}"
if [ $? = 0 ]; then
break
else
echo 'Failed to set password'
echo 'Please repeat the procedure'
tell_press_enter
fi
done

echo 'User :' "${config['user_name']}" 'added'

wait_and_clear 2

echo 'Installing SSH'

install_with_retries 'openssh'

wait_and_clear 2

echo 'Copying SSH server config over'

cp ../saltstack/salt/sshd_config /mnt/etc/ssh/

wait_and_clear 2

echo 'Enabling SSH server'

arch-chroot "${config['mount_path']}" systemctl enable sshd

wait_and_clear 2

echo 'Setting up SSH keys'

config['user_home']="${config['mount_path']}"/home/"${config['user_name']}" 
mkdir "${config['user_home']}"/.ssh
arch-chroot "${config['mount_path']}" chown "${config['user_name']}":"${config['user_name']}" /home/"${config['user_name']}"/.ssh
config['ssh_key_path']="${config['user_home']}"/.ssh/authorized_keys 
config['ip_addr']="$( ip route get 8.8.8.8 | awk '{print $(NF-2);exit}' )" 
config['port']=40001 

rm "${config['ssh_key_path']}"

while true; do
pass="$( cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1 )" 
echo 'Transfer the PUBLIC key to the server using one of the following commands'
echo 'cat PUBKEY | gpg -c | ncat '"${config['ip_addr']}"' '"${config['port']}"' # enter passphrase '"${pass}"' when prompted'
echo 'or'
echo 'cat PUBKEY | gpg --batch --yes --passphrase '"${pass}"' -c | ncat '"${config['ip_addr']}"' '"${config['port']}"''
ncat -lp "${config['port']}" > pub_key.gpg
echo 'File received'
echo 'Decrypting file'
echo '=========='
gpg --batch --yes --passphrase "${pass}" -o pub_key --decrypt pub_key.gpg
ret=$? 
echo '=========='
echo ''
if [ "${ret}" = 0 ]; then
echo 'SHA256 hash of decrypted file :' "$( sha256sum pub_key )"
ask_end=false 
while ! "${ask_end}"; do
ask_yn file_correct 'Does the hash match the hash of the original file?'
ask_if_correct ask_end
done
if "${file_correct}"; then
echo 'Installing SSH key for user :' "${config['user_name']}"
cat pub_key >> "${config['ssh_key_path']}"
arch-chroot "${config['mount_path']}" chown "${config['user_name']}":"${config['user_name']}" "${config['ssh_key_path']}"
rm pub_key
ask_yn add_another 'Do you want to add another SSH key?'
if "${add_another}"; then
echo 'Adding another SSH key, repeating procedure'
echo ''
tell_press_enter
else
break
fi
else
echo 'Incorrect file, repeating procedure'
echo ''
tell_press_enter
fi
else
echo 'Decryption failed'
echo ''
tell_press_enter
fi
rm -f pub_key.gpg
rm -f pub_key
clear
done

clear

wait_and_clear 2

echo 'Enabling dhcpcd'

arch-chroot "${config['mount_path']}" systemctl enable dhcpcd

wait_and_clear 2


echo 'Generating saltstack execution script'
config['salt_exec_script_name']='salt_exec.sh' 
config['salt_exec_script_path']="${config['lssh_dir_path']}"/"${config['salt_exec_script_name']}" 
cp salt_stack_execute_template "${config['salt_exec_script_path']}"
chown root:root "${config['salt_exec_script_path']}"
chmod u=rx "${config['salt_exec_script_path']}"
chmod g=rx "${config['salt_exec_script_path']}"
chmod o='' "${config['salt_exec_script_path']}"


install_with_retries 'salt'

wait_and_clear 2


echo 'Updating saltstack config'
sed -i 's@#file_client: remote@file_client: local@g' "${config['mount_path']}"/etc/salt/minion

wait_and_clear 2


config['saltstack_files_path']='../saltstack' 
echo 'Copying saltstack files over to system'
cp -r "${config['saltstack_files_path']}"/* "${config['mount_path']}"/srv

wait_and_clear 2


echo 'Configuring salt files to target user : '"${user_name}"
sed -i 's@USER_NAME_DUMMY@'"${config['user_name']}"'@g' "${config['mount_path']}"/srv/pillar/user.sls

wait_and_clear 2


echo 'Below is the configuration recorded'
print_map config
print_map config >> /root/lssh.config
print_map config >> "${config['mount_path']}"/root/lssh.config
echo 'The above output is also saved to /root/lssh.config and' "${config['mount_path']}"/root/lssh.config

echo ''

tell_press_enter
clear

end=false 
while ! "${end}"; do
ask_yn close_disks 'Do you want to close the partitions?'
ask_if_correct end
done

if "${close_disks}"; then
umount -R /mnt
fi

clear

if "${close_disks}"; then
end=false 
while ! "${end}"; do
ask_yn shutdown_system 'Do you want to shut down now?'
ask_if_correct end
done
if "${shutdown_system}"; then
poweroff
else
:
fi
else
echo 'No shutting down will be done by the script since the partitions are not closed'
wait_and_clear 2
fi

echo '==============='
echo ''
echo 'End of execution'
echo ''
echo '==============='



if [ "${ASYNC}" = 1 ]; then
wait
fi




