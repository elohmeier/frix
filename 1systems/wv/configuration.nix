{ config, lib, pkgs, ... }:

{
  imports = [
    ../../2configs/plasma-desktop
    ../../2configs/standard-filesystems.nix
    ../../2configs/hardware/intel.nix
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

  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = false;
    grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };
  };
}
