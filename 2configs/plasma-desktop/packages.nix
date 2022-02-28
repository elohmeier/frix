{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ark
    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    bat
    element-desktop
    fd
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
    nixpkgs-fmt
    xournalpp
  ];

  system.fsPackages = [ pkgs.ntfs3g ];
}
