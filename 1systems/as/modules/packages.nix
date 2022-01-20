{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bitwarden
    bitwarden-cli
    fd
    bat
    git
    vim
    vscodium
    nixpkgs-fmt
    firefox
    nmap
    wget
    btop

    run-kali-vm
    run-win-vm
  ];
}
