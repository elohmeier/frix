{ config, pkgs, ... }:


let
  hackertools = import ../../2configs/hackertools.nix { inherit pkgs; };
in
{
  imports =
    [
      ./hardware-configuration.nix
      ../../default.nix

      ../../2configs/default.nix
      ../../2configs/printers/hl5380dn.nix
    ];

  home-manager.users.ozzy = { ... }: {
    home.stateVersion = "21.05";
    home.packages = hackertools.infosec;
  };

  boot.tmpOnTmpfs = true;
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Configure networking
  networking = {
    hostName = "og";
    useNetworkd = true;
    useDHCP = false;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi = {
        backend = "iwd";
        macAddress = "random";
        powersave = true;
      };
    };
    wireless.iwd.enable = true;
  };

  services.resolved = {
    enable = true;
    dnssec = "false";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.layout = "de";

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
    media-session = {
      enable = true;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # speed up networking
  boot.kernelModules = [ "tcp_bbr" ];
  boot.kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr"; # affects both IPv4 and IPv6r

  security.polkit.enable = true;

  system.fsPackages = [ pkgs.ntfs3g ];

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

  hardware = {
    bluetooth = {
      enable = true;
      hsphfpd.enable = true;
      package = pkgs.bluezFull;
    };

    firmware = with pkgs; [
      firmwareLinuxNonfree
    ];

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };

  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ozzy = {
    isNormalUser = true;
    home = "/home/ozzy";
    createHome = true;
    useDefaultShell = true;
    uid = 1000;
    description = "Oscar Georgy";
    extraGroups = [ "libvirtd" "docker" "wheel" "networkmanager" "video" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    firefox
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
    samba
    vscodium
    fishPlugins.fzf-fish
    fishPlugins.done
    fzf
    zoxide
    fd
    bat
    ncdu
    freerdp
    sqlitebrowser
    virtviewer
    virtmanager
    wineWowPackages.stable # 32-bit & 64-bit
    (winetricks.override {
      wine = wineWowPackages.stable;
    })
    mpv
    obs-studio
    libreoffice-fresh
    inkscape
    gimp
    zoom-us
    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    hunspellDicts.de-de
    hunspellDicts.en-gb-large
    hunspellDicts.en-us-large
    tdesktop
  ];

  programs.fish = {
    enable = true;
    useBabelfish = true;

    shellAliases = {
      l = "ls -alh --color";
      la = "ls -alh --color";
      ll = "ls -l --color";
    };

    shellAbbrs = {
      ga = "git add";
      gc = "git commit";
      gs = "git status";
      gp = "git pull";
      gpp = "git push";
    };

    interactiveShellInit = ''
      set -U fish_greeting
      ${pkgs.zoxide}/bin/zoxide init fish | source
    '';

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
  programs.steam.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
