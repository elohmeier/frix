{ pkgs, ... }: {
  nixpkgs = {
    config.allowUnfree = true;
    config.packageOverrides = import ./5pkgs pkgs;
  };
}
