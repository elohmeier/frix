{ pkgs, ... }:

{
  home-manager.users.mainUser = { ... }: {
    home.stateVersion = "21.05";
    home.packages = with pkgs; [
      frixPython3Env
    ];

    programs.git = {
      enable = true;
      userEmail = "oscar.georgy@fraam.de";
      userName = "Oscar Georgy";
    };

    xsession.windowManager.i3 = {
      enable = true;
    };
  };
}
