{ pkgs, ... }:
{
  hardware = {
    bluetooth = {
      enable = true;
      hsphfpd.enable = true;
      package = pkgs.bluezFull;
    };
  };
}
