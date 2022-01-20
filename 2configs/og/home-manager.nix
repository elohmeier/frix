{ pkgs, ... }:

{
  home-manager.users.ozzy = { ... }: {
    home.stateVersion = "21.05";
    home.packages = with pkgs; hackertools ++ [
      frixPython2Env
      frixPython3Env
    ];

    programs.git = {
      enable = true;
      userEmail = "oscar.georgy@fraam.de";
      userName = "Oscar Georgy";
    };
  };
}
