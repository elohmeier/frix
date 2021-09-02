/*
  Installation from booted NixOS ISO
  ----------------------------------

  1. Format disk according to 2configs/hetzner-vm.nix
  2. Spawn Shell using `nix-shell -p nixFlakes gitMinimal`
  3. Run `nixos-install --flake git+https://git.fraam.de/fraam/frix#telefonbuch --no-root-passwd --no-channel-copy`
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

  networking.hostName = "telefonbuch";
  networking.firewall.enable = false;

  systemd.network.networks."40-en".networkConfig = {
    Address = "2a01:4f8:c0c:1992::1/64";
  };

  users.users.root.openssh.authorizedKeys.keys = [
    sshkeys.enno_yubi41
    sshkeys.enno_yubi49
  ];

  system.stateVersion = "21.05";

  services.nginx = {
    enable = true;
    virtualHosts."49.12.201.141" = {
      root = ./script;
      locations."~ \.php$".extraConfig = ''
        fastcgi_pass  unix:${config.services.phpfpm.pools.telefonbuch.socket};
      '';
    };
  };

  services.phpfpm.pools.telefonbuch = {
    user = config.services.nginx.user;
    settings = {
      pm = "dynamic";
      "listen.owner" = config.services.nginx.user;
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
      "pm.max_requests" = 500;
    };
  };
}
