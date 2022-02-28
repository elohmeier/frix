{ config, lib, modulesPath, pkgs, ... }:

{
  imports = [
    ../../2configs/plasma-desktop
    ../../2configs/standard-filesystems.nix
    ../../2configs/hardware/intel.nix

    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  environment.systemPackages = with pkgs; [
    vscode
  ];

  nix.maxJobs = 4;

  users.users.mainUser = {
    name = "wilko";
    home = "/home/wilko";
    description = "Wilko Volckens";
  };

  home-manager.users.mainUser = { ... }: {
    home.stateVersion = "21.11";

    programs.git = {
      enable = true;
      userEmail = "wilko.volckens@fraam.de";
      userName = "Wilko Volckens";
    };
  };

  system.stateVersion = "21.11";

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
      };
    };
  };
  fileSystems."/boot".device = "/dev/nvme0n1p3";

  hardware.firmware = with pkgs; [ firmwareLinuxNonfree ];
}
