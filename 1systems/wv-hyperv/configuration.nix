{ config, lib, pkgs, ... }:

{
  imports = [
    ../../2configs/wv.nix
  ];

  virtualisation.hypervGuest = {
    enable = true;
  };

  boot.loader.grub.device = "/dev/sda";

  fileSystems."/boot" = {
    device = "/dev/sda1";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/sda3";
    fsType = "ext4";
  };

  swapDevices = [{
    device = "/dev/sda2";
  }];

  nix.maxJobs = 4;
}
