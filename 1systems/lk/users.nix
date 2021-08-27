{ pkgs, ... }:

let
  hackertools = import ../../2configs/hackertools.nix { inherit pkgs; };
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    home = "/home/user";
    createHome = true;
    shell = pkgs.fish;
    uid = 1000;
    description = "";
    extraGroups = [ "libvirtd" "docker" "wheel" "networkmanager" "video" ];
  };

  # home-manager.users.user = { ... }: {
  #   home.stateVersion = "21.05";
  #   home.packages = hackertools.infosec;

  #   programs.git = {
  #     enable = true;
  #     userEmail = "liam.koehn@fraam.de";
  #     userName = "Liam Köhn";
  #   };
  # };
}
