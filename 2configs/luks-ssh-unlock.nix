# You should configure `boot.initrd.luks.devices` for this to function, e.g.:
# boot.initrd.luks.devices.sda2_crypt = {
#   device = "/dev/sda2";
#   preLVM = true;
# };

# use network cfg like this:
# networking.useDHCP = false;
# networking.interfaces."ensX".useDHCP = true;
# (tested with networkd)

# find your network driver module name using
# `ls -l /sys/class/net/<devname>/device/driver`
# and add it to boot.initrd.availableKernelModules

{ config, lib, pkgs, ... }:

{
  boot.initrd = {
    extraUtilsCommands =
      let
        unlock = pkgs.writeScriptBin "unlock" ''
          #!/bin/sh
          echo -n "Please enter LUKS passphrase: "
          IFS= read -rs passphrase
          echo -n "$passphrase" > /crypt-ramfs/passphrase
        '';
      in
      ''
        copy_bin_and_libs ${unlock}/bin/unlock
      '';
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 2222;
        hostKeys = [
          "/var/src/secrets/ssh.id_ed25519"
        ];
      };
      postCommands = ''
        echo "unlock" >> /root/.profile
      '';
    };
  };
}
