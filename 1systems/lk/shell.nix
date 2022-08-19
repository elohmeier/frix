{ config, pkgs, ... }:

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
    };

    interactiveShellInit = ''
      set -U fish_greeting
      ${pkgs.zoxide}/bin/zoxide init fish | source
    '';
  };

  home-manager.users.user = { config, pkgs, ... }: {
    xdg.configFile."fish/config.fish".text =
      let
        babelfishTranslate = path: name:
          pkgs.runCommand "${name}.fish"
            {
              nativeBuildInputs = [ pkgs.babelfish ];
            } "${pkgs.babelfish}/bin/babelfish < ${path} > $out;";
        hm-session-vars = pkgs.writeText "hm-session-vars.sh" (config.lib.shell.exportAll config.home.sessionVariables);
      in
      ''
        if not set -q __fish_general_config_sourced
          source ${babelfishTranslate hm-session-vars "hm-session-vars"} > /dev/null
          set -g __fish_general_config_sourced 1
        end
      
        if status is-login
          if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
            # pass sway log output to journald
            exec ${pkgs.systemd}/bin/systemd-cat --identifier=sway ${pkgs.sway}/bin/sway
          end
        end    
      '';
  };
}
