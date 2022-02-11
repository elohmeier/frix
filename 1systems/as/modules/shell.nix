{ pkgs, ... }:

{
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
      ".." = "cd ..";
    };

    interactiveShellInit = ''
      set -U fish_greeting
      ${pkgs.zoxide}/bin/zoxide init fish | source
    '';
  };

  environment.systemPackages = with pkgs; [
    fishPlugins.fzf-fish
    fishPlugins.done
    fzf
    zoxide
  ];

  programs.command-not-found.enable = false;
}
