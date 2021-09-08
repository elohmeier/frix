{ config, pkgs, ... }:

let
  sshkeys = import ../../2configs/sshkeys.nix;
in
{
  imports =
    [
      ../../default.nix
      ../../2configs/hetzner-vm-luks.nix
    ];

  networking.hostName = "matrix";

  systemd.network.networks."40-en".networkConfig = {
    Address = "2a01:4f8:c0c:1992::1/64";
  };

  boot.initrd.network.ssh.authorizedKeys = [
    sshkeys.enno_yubi41
    sshkeys.enno_yubi49
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    sshkeys.enno_yubi41
    sshkeys.enno_yubi49
  ];

  system.stateVersion = "21.05";
}
