{ config, pkgs, modulesPath, ... }:

let
  disk = "/dev/disk/by-id/nvme-KBG40ZNT512G_TOSHIBA_MEMORY_11TPG85HQXN2";
in
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ../../2configs/og
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" "dm-snapshot" ];
  boot.initrd.luks.devices.crypto.device = "${disk}-part2";
  boot.kernelModules = [ "kvm-amd" ];
  nix.maxJobs = 8;
  hardware.cpu.amd.updateMicrocode = true;

  fileSystems."/boot" =
    {
      device = "${disk}-part1";
      fsType = "vfat";
    };

  hardware.opengl = {
    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
      amdvlk
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  networking = {
    hostName = "og-e15";
    nat.externalInterface = "wlan0";
  };
}