{ config, lib, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ad = {
    isNormalUser = true;
    home = "/home/ad";
    createHome = true;
    shell = pkgs.zsh;
    uid = 1000;
    description = "ad";
    extraGroups = [
      "libvirtd"
      "docker"
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager"
      "video"
    ];
  };
}
