{ pkgs, ... }:

{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
      alacritty # Alacritty is the default terminal in the config
      dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
    ];
  };

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

  home-manager.users.user = { ... }: {

    programs.mako = {
      enable = true;
    };

    home = {
      keyboard = {
        layout = "de";
        variant = "nodeadkeys";
      };
    };

    wayland.windowManager.sway = {
      enable = true;
      config = {
        input = {
          "*" = {
            natural_scroll = "enabled";
            xkb_layout = "de";
            xkb_numlock = "enabled";
          };
        };
      };
    };
  };
}
