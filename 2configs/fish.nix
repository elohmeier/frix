{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    useBabelfish = true;

    shellAliases = {
      l = "ls -alh --color";
      la = "ls -alh --color";
      ll = "ls -l --color";
      ls = "ls --color";
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

  environment.systemPackages = [ pkgs.zoxide ];

  users.defaultUserShell = pkgs.fish;

  programs.command-not-found.enable = false;
}
