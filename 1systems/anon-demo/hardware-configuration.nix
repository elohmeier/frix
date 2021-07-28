{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  boot.initrd = {
    availableKernelModules =
      [ "ata_piix" "uhci_hcd" "virtio_net" "virtio_pci" "sd_mod" "sr_mod" ];
  };

  nix.maxJobs = 4;

  fileSystems."/" =
    {
      device = "/dev/sysVG/root";
      fsType = "ext4";
    };

  fileSystems."/nix" =
    {
      device = "/dev/sysVG/nix";
      fsType = "ext4";
    };

  fileSystems."/var" =
    {
      device = "/dev/sysVG/var";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/sda1";
      fsType = "ext4";
    };

  swapDevices =
    [{ device = "/dev/sysVG/swap"; }];
}
