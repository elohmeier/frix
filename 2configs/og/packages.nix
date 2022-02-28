{ lib, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim #Text editor
    wget #retrieve files via HTTP FTP
    rsync #syncronisation von daten
    nmap # Portscanner- scannen auswerten von Hosts ( networkmapper )
    tree
    nixpkgs-fmt
    keepassxc # free passwort manager
    signal-desktop #Messenger
    tdesktop # messenger Telegram
    redshift
    jetbrains.idea-community
    libsForQt5.ark
    teams #Appoinment and message administration tool
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
    sqlitebrowser
    virtviewer
    virtmanager
    wineWowPackages.stable # 32-bit & 64-bit
    winetricks
    mpv
    obs-studio
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
  ];

  programs.steam.enable = true;

  environment.pathsToLink = [ "/share/wordlists" ];

  system.activationScripts.initialize-SecLists = lib.stringAfter [ "users" "groups" ] ''
    rm -rf /home/ozzy/SecLists
    ln -sf ${pkgs.wordlists-seclists}/share/wordlists/SecLists /home/ozzy/SecLists
  '';
}
