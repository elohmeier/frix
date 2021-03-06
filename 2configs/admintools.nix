{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat
    btop
    fd
    ncdu
    (neovim.override { withPython3 = false; })
    (nnn.override { withNerdIcons = true; })
    ripgrep
  ];

  programs.fish.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };

  programs.tmux = {
    enable = true;
  };
}
