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
  sshkeys = import ../../2configs/sshkeys.nix;
in
{
  imports =
    [
      ../../default.nix
      ../../2configs/hetzner-vm.nix
    ];

  networking.hostName = "metrics";

  systemd.network.networks."40-en".networkConfig = {
    Address = "2a01:4f9:c011:9cb::1/64";
  };

  users.users.root.openssh.authorizedKeys.keys = [
    sshkeys.enno_yubi41
    sshkeys.enno_yubi49
    sshkeys.liam_arch
  ];

  system.stateVersion = "21.05";
}