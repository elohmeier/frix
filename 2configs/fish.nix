{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    useBabelfish = true;

    shellAliases = {
      l = "exa -al";
      la = "exa -al";
      lg = "exa -al --git";
      ll = "exa -l";
      ls = "exa";
      tree = "exa --tree";
    };

    shellAbbrs = {
      "cd.." = "cd ..";

      # systemd
      ctl = "systemctl";
      utl = "systemctl --user";
      jtl = "journalctl";
      ut = "systemctl --user start";
      un = "systemctl --user stop";
      up = "systemctl start";
      dn = "systemctl stop";
    };

    interactiveShellInit = ''
      set -U fish_greeting
      set booted (readlink /run/booted-system/{initrd,kernel,kernel-modules})
      set built (readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})
      if test "$booted" != "$built"
        echo "please reboot"
      end
                    
      function posix-source
        for i in (cat $argv)
          set arr (echo $i |tr = \n)
            set -gx $arr[1] $arr[2]
        end
      end

      ${pkgs.zoxide}/bin/zoxide init fish | source
    '';
  };

  environment.systemPackages = with pkgs; [
    exa
    fishPlugins.fzf-fish
    fzf
    zoxide
  ];

  users.defaultUserShell = pkgs.fish;

  programs.command-not-found.enable = false;
}
