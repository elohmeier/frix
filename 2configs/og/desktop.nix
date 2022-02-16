{ config, lib, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "de";

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager.i3.enable = true;

  # Enable sound.
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
    media-session = {
      enable = true;
    };
  };

  # required for screensharing in wayland
  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

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

  programs.ssh.startAgent = true;

  # fraam office
  services.xserver.videoDrivers = [ "displaylink" ];
  boot.kernelParams = [ "evdi.disable_texture_import=1" ];
}
