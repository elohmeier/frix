{ config, lib, pkgs, ... }:

let
  disk = "/dev/disk/by-id/nvme-SAMSUNG_MZALQ512HBLU-00BL1_S65CNE0R511927";
in
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices.crypto.device = "${disk}-part2";

  fileSystems."/" =
    {
      device = "/dev/sysVG/root";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "${disk}-part1";
      fsType = "vfat";
    };

  fileSystems."/home" =
    {
      device = "/dev/sysVG/home";
      fsType = "ext4";
      options = [ "nodev" "nosuid" ];
    };

  fileSystems."/var" =
    {
      device = "/dev/sysVG/var";
      fsType = "ext4";
      options = [ "nodev" "nosuid" "noexec" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/sysVG/nix";
      fsType = "ext4";
      options = [ "nodev" ];
    };

  swapDevices = [{ device = "/dev/sysVG/swap"; }];

  boot.tmpOnTmpfs = true;
}
