# frix

fraam nix configurations


## Running a Windows VM

Run the command `nix run .#run-win-vm` from the frix folder.
If you don't have the VM image in your Nix store already, Nix will download it for you.
The download progress might not be visible from the Nix output, you can run the following
command prior to running the above command to prefetch the VM image:
`nix-prefetch-url https://download.microsoft.com/download/9/0/8/90881435-55c1-4cf2-81f8-aae807702467/WinDev2112Eval.HyperVGen1.zip` (look up the concrete url from `./5pkgs/windows-vm-image/default.nix`).
The preparation of the VM image requires a image format conversion to qcow2 which requires 
around 40GiB of temporary space in `/tmp`. Ensure you have enough space available.
You can modify the size of a mounted tmpfs using e.g. the command `sudo mount -o remount,size=40G /tmp`.

## Fresh installation using standard partition layout

For using with the [standard partition layout](./2configs/standard-filesystems.nix).

```
export pass="YOURPASSWORD"
export disk="/dev/nvme0n1"
export RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')

sgdisk -og -a1 -n1:2048:+500M -t1:EF00 -c1:boot -n2:0:0 -t2:8309 -c2:crypto "$disk"
echo -n $pass | cryptsetup -q luksFormat /dev/disk/by-partlabel/crypto
echo -n $pass | cryptsetup luksOpen /dev/disk/by-partlabel/crypto crypto
pvcreate /dev/mapper/crypto
vgcreate sysVG /dev/mapper/crypto
lvcreate -L 1G -n root sysVG
lvcreate -L 10G -n home sysVG
lvcreate -L 30G -n nix sysVG
lvcreate -L 2G -n var sysVG
lvcreate -L ${RAM_KB}K -n swap sysVG
mkfs.ext4 -F /dev/sysVG/root
mkfs.ext4 -F /dev/sysVG/home
mkfs.ext4 -F /dev/sysVG/nix
mkfs.ext4 -F /dev/sysVG/var
mkswap /dev/sysVG/swap
mkfs.vfat -F 32 /dev/disk/by-partlabel/boot
mount /dev/sysVG/root /mnt/
mkdir /mnt/{boot,home,nix,var}
mount /dev/disk/by-partlabel/boot /mnt/boot
mount /dev/sysVG/home /mnt/home
mount /dev/sysVG/nix /mnt/nix
mount /dev/sysVG/var /mnt/var
swapon /dev/sysVG/swap
```
