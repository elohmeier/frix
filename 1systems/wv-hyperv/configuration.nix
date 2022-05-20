{ config, lib, pkgs, ... }:

{
  imports = [
    ../../2configs/wv.nix
    ../../2configs/standard-filesystems.nix
  ];

  virtualisation.hypervGuest.enable = true;

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub.device = "/dev/sda";
  };


  nix.maxJobs = 4;
}
