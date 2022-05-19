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

    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    # optional for nix flakes support in home-manager 21.11, not required in home-manager unstable or 22.05
    programs.direnv.nix-direnv.enableFlakes = true;
  };
}
