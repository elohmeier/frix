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

  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
    extraPortals = with pkgs;[ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
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

    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "monospace:size=11";
          dpi-aware = "yes";
        };
      };
    };

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

        keybindings =
          let
            modifier = "Mod1";
          in
          {
            "${modifier}+Return" = "exec ${pkgs.foot}/bin/foot";
            "${modifier}+Shift+q" = "kill";
            "${modifier}+d" = "exec ${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";
            "Print" = ''exec ${pkgs.grim}/bin/grim -t png -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -'';
            "${modifier}+h" = "focus left";
            "${modifier}+j" = "focus down";
            "${modifier}+k" = "focus up";
            "${modifier}+l" = "focus right";

            "${modifier}+Left" = "focus left";
            "${modifier}+Down" = "focus down";
            "${modifier}+Up" = "focus up";
            "${modifier}+Right" = "focus right";

            "${modifier}+Shift+h" = "move left";
            "${modifier}+Shift+j" = "move down";
            "${modifier}+Shift+k" = "move up";
            "${modifier}+Shift+l" = "move right";

            "${modifier}+Shift+Left" = "move left";
            "${modifier}+Shift+Down" = "move down";
            "${modifier}+Shift+Up" = "move up";
            "${modifier}+Shift+Right" = "move right";

            "${modifier}+b" = "splith";
            "${modifier}+v" = "splitv";
            "${modifier}+f" = "fullscreen toggle";
            "${modifier}+a" = "focus parent";

            "${modifier}+s" = "layout stacking";
            "${modifier}+w" = "layout tabbed";
            "${modifier}+e" = "layout toggle split";

            "${modifier}+Shift+space" = "floating toggle";
            "${modifier}+space" = "focus mode_toggle";

            "${modifier}+1" = "workspace number 1";
            "${modifier}+2" = "workspace number 2";
            "${modifier}+3" = "workspace number 3";
            "${modifier}+4" = "workspace number 4";
            "${modifier}+5" = "workspace number 5";
            "${modifier}+6" = "workspace number 6";
            "${modifier}+7" = "workspace number 7";
            "${modifier}+8" = "workspace number 8";
            "${modifier}+9" = "workspace number 9";

            "${modifier}+Shift+1" =
              "move container to workspace number 1";
            "${modifier}+Shift+2" =
              "move container to workspace number 2";
            "${modifier}+Shift+3" =
              "move container to workspace number 3";
            "${modifier}+Shift+4" =
              "move container to workspace number 4";
            "${modifier}+Shift+5" =
              "move container to workspace number 5";
            "${modifier}+Shift+6" =
              "move container to workspace number 6";
            "${modifier}+Shift+7" =
              "move container to workspace number 7";
            "${modifier}+Shift+8" =
              "move container to workspace number 8";
            "${modifier}+Shift+9" =
              "move container to workspace number 9";

            "${modifier}+Shift+minus" = "move scratchpad";
            "${modifier}+minus" = "scratchpad show";

            "${modifier}+Shift+c" = "reload";
            "${modifier}+Shift+e" =
              "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

            "${modifier}+r" = "mode resize";
          };

        input = {
          "*" = {
            xkb_layout = "de";
            xkb_numlock = "enabled";
          };
        };

        output = {
          "*" = {
            # bg = "~/path/to/background.png fill";
          };

          "eDP-1" = {
            pos = "0 0";
          };

          "HannStar Display Corp HS246 1234567890123" = {
            pos = "1920 0";
          };
        };
      };
    };
  };
}
