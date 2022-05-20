{ config, lib, modulesPath, pkgs, ... }:

{
  imports = [
    ../../2configs/crypto-systemdboot.nix
    ../../2configs/standard-filesystems.nix
    ../../2configs/hardware/intel.nix
    ../../2configs/wv.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  nix.maxJobs = 4;

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices.crypto.device = "/dev/nvme0n1p4";
    };
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = false;
      grub = {
        enable = true;
        version = 2;
        device = "/dev/nvme0n1";
        extraEntries = ''
          menuentry "Windows 10" {
            chainloader (hd0,1)+1
          }
        '';
      };
    };
  };
  fileSystems."/boot".device = "/dev/nvme0n1p3";

  hardware.firmware = with pkgs; [ firmwareLinuxNonfree ];
  services.xserver.videoDrivers = [ "displaylink" ]; # fraam office
}
