{ config, lib, pkgs, ... }:

{
  boot = {
    tmpOnTmpfs = lib.mkDefault true;
    initrd.luks.devices.crypto.device = lib.mkDefault "/dev/disk/by-label/crypto";
    loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi.canTouchEfiVariables = lib.mkDefault true;
    };
  };

  fileSystems = {
    "/" =
      {
        device = "/dev/sysVG/root";
        fsType = "ext4";
      };

    "/boot" =
      {
        device = lib.mkDefault "/dev/disk/by-label/boot";
        fsType = "vfat";
      };

    "/home" =
      {
        device = "/dev/sysVG/home";
        fsType = "ext4";
        options = [ "nodev" "nosuid" ];
      };

    "/var" =
      {
        device = "/dev/sysVG/var";
        fsType = "ext4";
        options = [ "nodev" "nosuid" "noexec" ];
      };

    "/nix" =
      {
        device = "/dev/sysVG/nix";
        fsType = "ext4";
        options = [ "nodev" ];
      };
  };

  swapDevices = [
    { device = "/dev/sysVG/swap"; }
  ];
}
