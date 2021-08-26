/*
  Installation from booted NixOS ISO
  ----------------------------------

  1. Format disk according to 2configs/hetzner-vm.nix
  2. Spawn Shell using `nix-shell -p nixFlakes gitMinimal`
  3. Run `nixos-install --flake git+https://git.fraam.de/fraam/frix#anon-demo`
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
      ./presidio-demo.nix
    ];

  networking = {
    hostName = "anon-demo";
    interfaces.ens3.ipv6.addresses = [
      { address = "2a01:4f8:1c1c:e884::1"; prefixLength = 64; }
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    sshkeys.enno_yubi41
    sshkeys.enno_yubi49
  ];

  system.stateVersion = "21.05";
}
