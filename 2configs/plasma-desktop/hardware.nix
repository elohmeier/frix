{ config, lib, pkgs, ... }:

{
  hardware = {
    bluetooth = {
      enable = lib.mkDefault true;
      hsphfpd.enable = lib.mkDefault true;
      package = lib.mkDefault pkgs.bluezFull;
    };

    firmware = with pkgs; [
      firmwareLinuxNonfree
    ];

    opengl = {
      enable = lib.mkDefault true;
      driSupport = lib.mkDefault true;
      driSupport32Bit = lib.mkDefault true;
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";
}
