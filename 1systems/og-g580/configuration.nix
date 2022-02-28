{ config, pkgs, modulesPath, ... }:

let
  disk = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_250GB_S3YJNB1K254742Z";
in
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ../../2configs/og
      ../../2configs/hardware/intel.nix
      ../../2configs/kiosk.nix
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.initrd.luks.devices.crypto.device = "${disk}-part2";
  nix.maxJobs = 4;

  fileSystems."/boot".device = "${disk}-part1";

  networking = {
    hostName = "og-g580";
    nat.externalInterface = "wlan0";
  };
}
