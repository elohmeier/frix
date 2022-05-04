{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./amd.nix
  ];

  nix.maxJobs = 8;

  boot.extraModulePackages = [ config.boot.kernelPackages.rtw89 ];
  hardware.firmware = with pkgs; [ rtw89-firmware ];
}
