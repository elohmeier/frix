{ config, lib, pkgs, ... }:

{
  imports = [
    ./plasma-desktop
  ];

  environment.systemPackages = with pkgs; [
    frixPython3Env
    vscode
  ];

  system.stateVersion = lib.mkDefault "21.11";

  users.users.mainUser = {
    name = "wilko";
    home = "/home/wilko";
    description = "Wilko Volckens";
  };

  home-manager.users.mainUser = { lib, ... }: {
    home.stateVersion = lib.mkDefault "21.11";

    programs.git = {
      enable = true;
      userEmail = "wilko.volckens@fraam.de";
      userName = "Wilko Volckens";
    };
  };
}
