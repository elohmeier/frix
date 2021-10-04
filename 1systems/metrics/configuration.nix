/*
  Installation from booted NixOS ISO
  ----------------------------------

  1. Format disk according to 2configs/hetzner-vm.nix
  2. Spawn Shell using `nix-shell -p nixFlakes gitMinimal`
  3. Run `nixos-install --flake git+https://git.fraam.de/fraam/frix#metrics --no-root-passwd --no-channel-copy`
  4. Reboot

*/

{ config, pkgs, ... }:

let
  sshkeys = with import ../../2configs/sshkeys.nix; [ enno_yubi41 enno_yubi49 liam ];
in
{
  imports =
    [
      ../../default.nix
      ../../2configs/hetzner-vm.nix

      ./acme.nix
      ./grafana.nix
      ./nginx.nix
      ./ports.nix
      ./prometheus.nix
      ./traefik.nix
    ];

  networking.hostName = "metrics";

  systemd.network.networks."40-en".networkConfig = {
    Address = "2a01:4f9:c011:9cb::1/64";
  };

  users.users.root.openssh.authorizedKeys.keys = sshkeys;

  system.stateVersion = "21.05";
}
