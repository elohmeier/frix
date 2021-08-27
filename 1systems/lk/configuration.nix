{ config, pkgs, ... }:

{
  imports =
    [
      ./desktop.nix
      ./hardware-configuration.nix
      ./networking.nix
      ./packages.nix
      ./shell.nix
      ./users.nix

      ../../default.nix

      ../../2configs/default.nix
      ../../2configs/printers/hl5380dn.nix
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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  security.polkit.enable = true;

  services.upower.enable = true;

  services.timesyncd = {
    enable = true;
    servers = [
      "0.de.pool.ntp.org"
      "1.de.pool.ntp.org"
      "2.de.pool.ntp.org"
      "3.de.pool.ntp.org"
    ];
  };

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false; # will be socket-activated
    };
    libvirtd = {
      enable = true;
      qemuPackage = pkgs.qemu_kvm;
      qemuRunAsRoot = false;
    };
    spiceUSBRedirection.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
