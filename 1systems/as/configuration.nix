{ config, lib, pkgs, ... }:

{
  imports = [
    ./modules/filesystems.nix
    ./modules/hardware.nix
    ./modules/networking.nix
    ./modules/packages.nix
    ./modules/users.nix
    ./modules/shell.nix
    ./modules/virtualisation.nix
  ];


  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

  services.xserver.desktopManager.plasma5.enable = lib.mkDefault true;
  services.xserver.enable = lib.mkDefault true;
  services.xserver.layout = "de";
  services.xserver.displayManager.sddm.enable = lib.mkDefault true;

  specialisation.sway.configuration = {
    services.xserver.desktopManager.plasma5.enable = false;
    services.xserver.enable = false;
    services.xserver.displayManager.sddm.enable = false;

    programs.sway.enable = true;
  };

  #  programs.zsh.enable = true;
  #  programs.zsh.ohMyZsh.enable = true;

}
