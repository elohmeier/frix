# opinionated default fraam KDE desktop config & other defaults
{ config, lib, pkgs, ... }:

{
  imports = [
    ../default.nix
    ../printers/hl5380dn.nix

    ./hardware.nix
    ./home-manager.nix
    ./networking.nix
    ./packages.nix
    ./shell.nix
    ./sound.nix
    ./users.nix
    ./xserver.nix
  ];

  programs.ssh.startAgent = true;

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = lib.mkDefault "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = lib.mkDefault "de_DE.UTF-8";

  console = {
    font = lib.mkDefault "Lat2-Terminus16";
    keyMap = lib.mkDefault "de";
  };

  security.polkit.enable = true;
  services.upower.enable = lib.mkDefault true;

  # Enable CUPS to print documents.
  services.printing.enable = lib.mkDefault true;

  services.timesyncd = {
    enable = lib.mkDefault true;
    servers = [
      "0.de.pool.ntp.org"
      "1.de.pool.ntp.org"
      "2.de.pool.ntp.org"
      "3.de.pool.ntp.org"
    ];
  };
}
