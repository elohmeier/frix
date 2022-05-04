{ config, lib, pkgs, ... }:

{
  hardware = {
    bluetooth = {
      enable = true;
      hsphfpd.enable = true;
      package = pkgs.bluezFull;
    };

    firmware = with pkgs; [
      firmwareLinuxNonfree
    ];
  };
}
