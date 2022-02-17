{ lib, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim #Text editor
    wget #retrieve files via HTTP FTP
    firefox #Browser
    rsync #syncronisation von daten
    nmap # Portscanner- scannen auswerten von Hosts ( networkmapper )
    tree
    nixpkgs-fmt
    keepassxc # free passwort manager
    signal-desktop #Messenger
    tdesktop # messenger Telegram
    redshift
    flameshot # bildschirm aufnahme programm für Linux
    git # git halt
    jetbrains.idea-community
    libsForQt5.ark
    teams #Appoinment and message administration tool
    tree
    ffmpeg # Video and picture alter program
    youtube-dl # lets you download yt vidoes
    vlc #mediaplayer
    kdenlive #video schnitt software
    freetts
    jetbrains.datagrip
    sqsh #Sql shell for linux
    thc-hydra #bruteforce  
    samba
    vscodium # fürs coden
    fishPlugins.fzf-fish
    fishPlugins.done
    fzf #fuzzy suche
    zoxide
    fd
    bat
    ncdu
    freerdp
    sqlitebrowser
    virtviewer
    virtmanager
    wineWowPackages.stable # 32-bit & 64-bit
    winetricks
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
    # mysql-workbench # requires broken py2 package 
    discord
    teams
    wordlists-seclists
    dbeaver
    sqlfluff
    xournalpp # pdf editor
  ];

  system.fsPackages = [ pkgs.ntfs3g ];

  programs.steam.enable = true;

  environment.pathsToLink = [ "/share/SecLists" ];

  system.activationScripts.initialize-SecLists = lib.stringAfter [ "users" "groups" ] ''
    rm -rf /home/ozzy/SecLists
    ln -sf ${pkgs.wordlists-seclists}/share/SecLists /home/ozzy/SecLists
  '';
}
