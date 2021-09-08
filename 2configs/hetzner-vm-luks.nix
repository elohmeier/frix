/*

  Default config for hetzner cloud virtual machines with encrypted root disk.
  ---------------------------------------------------------------------------

  Prepare the disk when installing using:

  export pass="YOURPASSWORD"

  sgdisk -og -a1 -n1:2048:+200M -t1:8300 -n3:-1M:0 -t3:EF02 -n2:0:0 -t2:8309 /dev/sda
  echo -n $pass | cryptsetup -q luksFormat /dev/sda2
  echo -n $pass | cryptsetup luksOpen /dev/sda2 sda2_crypt
  pvcreate /dev/mapper/sda2_crypt
  vgcreate sysVG /dev/mapper/sda2_crypt
  lvcreate -L 1G -n root sysVG
  lvcreate -L 6G -n nix sysVG
  lvcreate -L 2G -n var sysVG
  lvcreate -L 4G -n swap sysVG
  mkfs.ext4 -F /dev/sysVG/root
  mkfs.ext4 -F /dev/sysVG/nix
  mkfs.ext4 -F /dev/sysVG/var
  mkfs.ext4 -F /dev/sda1
  mkswap /dev/sysVG/swap
  mount /dev/sysVG/root /mnt/
  mkdir /mnt/{boot,nix,var}
  mount /dev/sda1 /mnt/boot
  mount /dev/sysVG/nix /mnt/nix
  mount /dev/sysVG/var /mnt/var

*/

{ ... }:

{
  imports = [
    ./hetzner-vm.nix
    ./luks-ssh-unlock.nix
  ];

  boot.initrd.luks.devices.sda2_crypt = {
    device = "/dev/sda2";
    preLVM = true;
  };
}
