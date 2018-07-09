


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
while [ $(( ${end} )) -eq $(( ${false:-0} )) ]; do
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
while [ $(( ${end} )) -eq $(( ${false:-0} )) ]; do
"${config['editor']}" "${mirrorlist_path}"
clear
ask_yn end 'Finished editing'
done

clear


echo 'Choose system partition'
echo ''

end=false 
while [ $(( ${end} )) -eq $(( ${false:-0} )) ]; do
ask_ans config['sys_disk'] 'Please specify the system disk'
if [ -b "${config['sys_disk']}" ]; then
echo 'System parition picked :' ''"${config}"'['sys_disk']'
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

if [ $(( "${config['efi_mode']}" )) -eq $(( ${true:-0} )) ]; then
echo 'Creating GPT partition table'
parted -s "${config['sys_disk']}" mklabel gpt &>/dev/null
echo 'Calculating partition sizes'
esp_part_size=200 
esp_part_perc="$( div_rup ( "${esp_part_size}" * 100 ) "${config['sys_disk_size_MiB']}" )" 
esp_part_beg_perc=0 
esp_part_end_perc="${esp_part_perc}" 
boot_part_size=200 
boot_part_perc="$( div_rup ( "${esp_part_end_perc}" * 100 ) "${config['sys_disk_size_MiB']}" )" 
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
boot_part_perc="$( div_rup ( "${boot_part_size}" * 100 ) "${config['sys_disk_size_MiB']}" )" 
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


