{ config, pkgs, modulesPath, ... }:

let
  disk = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_250GB_S3YJNB1K254742Z";
in
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ../../2configs/og
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.initrd.luks.devices.crypto.device = "${disk}-part2";
  boot.kernelModules = [ "kvm-intel" ];
  nix.maxJobs = 4;
  hardware.cpu.intel.updateMicrocode = true;

  fileSystems."/boot" =
    {
      device = "${disk}-part1";
      fsType = "vfat";
    };
  hardware.opengl = {
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.vaapiIntel
    ];
  };

  services.xserver.videoDrivers = [ "modesetting" ];

  networking = {
    hostName = "og-g580";
    nat.externalInterface = "wlan0";
  };
}
