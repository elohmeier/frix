{ config, lib, pkgs, ... }:

{
  users.defaultUserShell = pkgs.fish;

  programs.fish = {
    enable = true;
    useBabelfish = true;

    shellAliases = {
      l = "exa -al";
      la = "exa -al";
      ll = "exa -l";
      ls = "exa";
      tree = "exa --tree";
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

  programs.command-not-found.enable = lib.mkDefault false;

  environment.systemPackages = with pkgs; [
    btop
    exa
    fishPlugins.fzf-fish
    fishPlugins.done
    fzf
    zoxide
  ];
}
