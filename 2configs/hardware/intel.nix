{ config, lib, pkgs, ... }:

{
  boot.kernelModules = [ "kvm-intel" ];

  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl = {
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
  };

  services.xserver.videoDrivers = [ "modesetting" ];
}
