{ lib, pkgs, ... }:

{
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
    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    hunspellDicts.de-de
    hunspellDicts.en-gb-large
    hunspellDicts.en-us-large
    tdesktop
    quota
    dsvpn
    iftop
    element-desktop
    poetry
    chromium
    mysql-workbench
    discord
    teams
    wordlists-seclists
    dbeaver
    sqlfluff
  ];

  system.fsPackages = [ pkgs.ntfs3g ];

  programs.steam.enable = true;

  environment.pathsToLink = [ "/share/SecLists" ];
  
  system.activationScripts.initialize-SecLists = lib.stringAfter [ "users" "groups" ] ''
    rm -rf /home/ozzy/SecLists
    ln -sf ${pkgs.wordlists-seclists}/share/SecLists /home/ozzy/SecLists
  '';
}
