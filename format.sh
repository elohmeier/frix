#!/usr/bin/env bash

# to run this script you can use e.g.
# curl https://raw.githubusercontent.com/elohmeier/frix/master/format.sh | bash -s -- /dev/sda

set -e

if [ "$EUID" -ne 0 ]; then
	echo "please run this script as root"
	exit
fi

DISK="${1?must provide disk}"

# eject eventually active volume groups
lvchange -an sysVG || true
vgexport -a

echo Formatting disk $DISK

export RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')

if (($RAM_KB <= 2097152)); then
	SWAP_KB=$(expr 2 '*' "$RAM_KB")
elif (($RAM_KB <= 8388608)); then
	SWAP_KB=$RAM_KB
else
	SWAP_KB=8388608
fi

echo configuring swap to $SWAP_KB KiB

parted -a optimal --script "$DISK" \
	mklabel gpt \
	mkpart grub 1MiB 2MiB \
	set 1 bios_grub on \
	mkpart boot fat32 2MiB 514MiB \
	set 2 boot on \
	mkpart lvm 514MiB 100% \
	set 3 lvm on

pvcreate -ff -y ${DISK}3
vgcreate sysVG ${DISK}3
lvcreate -L 500M -n root -y sysVG
lvcreate -L 1G -n home -y sysVG
lvcreate -L 17G -n nix -y sysVG
lvcreate -L 500M -n var -y sysVG
lvcreate -L ${SWAP_KB}K -n swap -y sysVG
mkfs.ext4 -F /dev/sysVG/root
mkfs.ext4 -F /dev/sysVG/home
mkfs.ext4 -F /dev/sysVG/nix
mkfs.ext4 -F /dev/sysVG/var
mkswap /dev/sysVG/swap
mkfs.vfat -F 32 ${DISK}2
mount /dev/sysVG/root /mnt/
mkdir /mnt/{boot,home,nix,var}
mount ${DISK}2 /mnt/boot
mount /dev/sysVG/home /mnt/home
mount /dev/sysVG/nix /mnt/nix
mount /dev/sysVG/var /mnt/var
swapon /dev/sysVG/swap

echo successfully formatted disk and mounted to /mnt, you can now install NixOS
