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
    sqlitebrowser
    virtviewer
    virtmanager
    wineWowPackages.stable # 32-bit & 64-bit
    winetricks
    mpv
    obs-studio #Aufnahme anwedung
    libreoffice-fresh
    inkscape #Pseudo Photoshop
    gimp #Bildbearbeitungs anwendung
    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    hunspellDicts.de-de
    hunspellDicts.en-gb-large
    hunspellDicts.en-us-large
    tdesktop #Telegram messenger
    quota
    dsvpn
    iftop
    element-desktop #Element Messenger
    poetry
    chromium #Chrom für Nix 
    # mysql-workbench # requires broken py2 package 
    discord #Discord halt
    teams #teams halt
    wordlists-seclists
    dbeaver # Datenbank programm
    sqlfluff
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        eamodio.gitlens
        editorconfig.editorconfig
        esbenp.prettier-vscode
        jkillian.custom-local-formatters
        jnoortheen.nix-ide
        ms-python.python
        ms-toolsai.jupyter
        ms-vsliveshare.vsliveshare
      ];
    })
  ];

  programs.steam.enable = true;

  environment.pathsToLink = [ "/share/wordlists" ];

  system.activationScripts.initialize-SecLists = lib.stringAfter [ "users" "groups" ] ''
    rm -rf /home/ozzy/SecLists
    ln -sf ${pkgs.wordlists-seclists}/share/wordlists/SecLists /home/ozzy/SecLists
  '';
}
