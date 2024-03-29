{ pkgs, ... }:

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
    wireshark
    ncdu
    freerdp
    sqlitebrowser
    virt-viewer
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
    foot
    faraday-cli
    naabu
    amass
    nuclei
    httpx
    postgresql
  ];

  system.fsPackages = [ pkgs.ntfs3g ];
}
