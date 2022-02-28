{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    bat
    fd
    firefox
    flameshot
    freerdp
    git
    gimp
    hunspellDicts.de-de
    hunspellDicts.en-gb-large
    hunspellDicts.en-us-large
    inkscape
    libreoffice-fresh
    ncdu
    xournalpp
  ];

  system.fsPackages = [ pkgs.ntfs3g ];
}