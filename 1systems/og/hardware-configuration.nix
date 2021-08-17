{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" "dm-snapshot" ];
  boot.initrd.luks.devices.crypto.device = "/dev/disk/by-id/nvme-KBG40ZNT512G_TOSHIBA_MEMORY_11TPG85HQXN2-part2";
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  nix.maxJobs = 8;
  hardware.cpu.amd.updateMicrocode = true;

  fileSystems."/" =
    {
      device = "/dev/sysVG/root";
      fsType = "ext4";
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

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-id/nvme-KBG40ZNT512G_TOSHIBA_MEMORY_11TPG85HQXN2-part1";
      fsType = "vfat";
    };

  swapDevices = [{ device = "/dev/sysVG/swap"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
