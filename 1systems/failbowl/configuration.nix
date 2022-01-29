# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, modulesPath, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../default.nix
      ../../2configs/nvidia-headless.nix
      # Include brother scanner support
      (modulesPath + "/services/hardware/sane_extra_backends/brscan4.nix")
    ];
  home-manager.users.simon = { ... }: {
    home.stateVersion = "21.05";
    home.packages = with pkgs; hackertools ++ [
      frixPython2Env
      frixPython3Env
    ];
  };

  boot.tmpOnTmpfs = true;
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nixpkgs.config.allowUnfree = true;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "failbowl"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  #networking.useDHCP = false;
  #networking.interfaces.enp58s0u1u3.useDHCP = true;
  #networking.interfaces.wlan0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "intel-media-driver" ];

  hardware.opengl = {
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapi-intel-hybrid
        vaapiVdpau
        libvdpau-va-gl
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.vaapiIntel
      ];
    };

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;


  # Configure keymap in X11
  services.xserver.layout = "de";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Enable scanner support
  hardware.sane = {
    enable = true;
    brscan4 = {
      enable = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.simon = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "scanner" "lp" ]; # Enable ‘sudo’ and scanning for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
    })
    rsync
    nmap
    tree
    nixpkgs-fmt
    keepassxc
    signal-desktop
    tdesktop
    redshift
    flameshot
    git
    jetbrains.idea-community
    libsForQt5.ark
    tor-browser-bundle-bin
    teams
    discord
    tree
    ffmpeg
    youtube-dl
    vlc
    kdenlive
    freetts
    jetbrains.datagrip
    sqsh
    thc-hydra
    vokoscreen
    libreoffice
    kate
    libsForQt5.okular
    teamspeak_client
    nix-tree
    htop
    neochat
    steam
    pciutils
    spotify
    gimp
    pdfsam-basic
    kdenlive
    smartmontools
    playonlinux
    #imagemagick
    inkscape
    google-chrome
    evince
    vnstat
    teams
    brlaser
    skanlite
    #gscan2pdf
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

