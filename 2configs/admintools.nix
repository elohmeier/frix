{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat
    bottom
    fd
    mc
    ncdu
    neovim
    (nnn.override { withNerdIcons = true; })
    ripgrep
    tree
  ];

  programs.fish.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };

  programs.tmux = {
    enable = true;
  };
}
