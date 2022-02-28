{ config, lib, pkgs, ... }:

{
  users.users.mainUser = {
    isNormalUser = true;
    createHome = true;
    useDefaultShell = true;
    uid = 1000;
    extraGroups = [
      "docker"
      "libvirtd"
      "networkmanager"
      "video"
      "wheel" # Enable ‘sudo’ for the user.
    ];
  };
}
