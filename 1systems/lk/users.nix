{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    home = "/home/user";
    createHome = true;
    shell = pkgs.fish;
    uid = 1000;
    description = "";
    extraGroups = [ "libvirtd" "docker" "wheel" "networkmanager" "video" "wireshark" ];
  };

  home-manager.users.user = { ... }: {
    home.stateVersion = "21.05";
    home.packages = with pkgs; hackertools ++ [
      frixPython2Env
      frixPython3Env
    ];
    programs.git = {
      enable = true;
      userEmail = "liam.koehn@fraam.de";
      userName = "Liam Köhn";
    };

    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    # optional for nix flakes support in home-manager 21.11, not required in home-manager unstable or 22.05
    programs.direnv.nix-direnv.enableFlakes = true;
  };
}
