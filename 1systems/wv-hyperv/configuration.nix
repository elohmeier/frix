{ config, lib, modulesPath, pkgs, ... }:

{
  imports = [
    ../../2configs/wv.nix
    (modulesPath + "/virtualisation/hyperv-guest.nix")
  ];

  boot.loader.grub.device = "/dev/sda";

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  nix.maxJobs = 4;
}
