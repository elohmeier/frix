{ config, pkgs, ... }:

let
  sshkeys = with import ../../2configs/sshkeys.nix; [ enno_yubi41 enno_yubi49 ];
in
{
  imports =
    [
      ../../default.nix
      ../../2configs/hetzner-vm-luks.nix

      ./acme.nix
      ./coturn.nix
      ./nginx.nix
      ./ports.nix
      ./synapse.nix
      ./traefik.nix
    ];

  networking.hostName = "matrix";

  systemd.network.networks."40-en".networkConfig = {
    Address = "2a01:4f8:c0c:1992::1/64";
  };

  boot.initrd.network.ssh.authorizedKeys = sshkeys;
  users.users.root.openssh.authorizedKeys.keys = sshkeys;

  system.stateVersion = "21.05";
}
