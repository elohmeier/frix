


# Provision Hetzner-VM

## Format disk

```bash
sgdisk -og -a1 -n1:2048:+200M -t1:8300 -n3:-1M:0 -t3:EF02 -n2:0:0 -t2:8300 /dev/sda
pvcreate /dev/sda2
vgcreate sysVG /dev/sda2
lvcreate -L 1G -n root sysVG
lvcreate -L 6G -n nix sysVG
lvcreate -L 2G -n var sysVG
lvcreate -L 2G -n sway sysVG
mkfs.ext4 -F /dev/sysVG/root
mkfs.ext4 -F /dev/sysVG/nix
mkfs.ext4 -F /dev/sysVG/var
mkfs.ext4 -F /dev/sda1
mkswap /dev/sysVG/swap
mount /dev/vg/root /mnt/
mkdir /mnt/{boot,nix,var}
mount /dev/sda1 /mnt/boot
mount /dev/sysVG/nix /mnt/nix
mount /dev/sysVG/var /mnt/var
```

## Install

Using `nixos-install --flake git+https://git.fraam.de/fraam/frix#anon-demo`


