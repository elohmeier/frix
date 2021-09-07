{ pkgs, ... }:

let
  hackertools = import ../hackertools.nix { inherit pkgs; };
in
{
  home-manager.users.ozzy = { ... }: {
    home.stateVersion = "21.05";
    home.packages = hackertools.infosec;

    programs.git = {
      enable = true;
      userEmail = "oscar.georgy@fraam.de";
      userName = "Oscar Georgy";
    };
  };
}
