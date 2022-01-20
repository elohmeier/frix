{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  nix.maxJobs = 8;

  boot.extraModulePackages = [ config.boot.kernelPackages.rtw89 ];
  hardware.firmware = with pkgs; [ rtw89-firmware ];

  hardware.cpu.amd.updateMicrocode = true;

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
}
