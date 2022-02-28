{ config, lib, pkgs, ... }:

{
  fonts.fonts = with pkgs; [
    cozette
    iosevka
    nerdfonts
    proggyfonts
    roboto
    roboto-slab
    source-code-pro
    win10fonts
  ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "de";

    # Enable the Plasma 5 Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

  # required for screensharing in wayland
  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
  };
}
