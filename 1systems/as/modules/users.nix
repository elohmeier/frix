{ config, lib, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ad = {
    isNormalUser = true;
    home = "/home/ad";
    createHome = true;
    shell = pkgs.fish;
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

  home-manager.users.ad = { config, lib, pkgs, nixosConfig, ... }:
    {
      home.stateVersion = "21.11";
      home.packages = with pkgs; hackertools ++ [
        frixPython2Env
        frixPython3Env
      ];

      programs.git = {
        enable = true;
        userEmail = "adrian.steins@fraam.de";
        userName = "Adrian Steins";
      };
    };
}
