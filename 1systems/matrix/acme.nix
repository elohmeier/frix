{ config, lib, pkgs, ... }:

let
  webroot = "/var/lib/acme/acme-challenge";
  group = "certs";
  postRun = "systemctl restart traefik.service";
in
{
  security.acme = {
    email = "enno.richter+acme@fraam.de";
    acceptTerms = true;
    certs = {
      "chat.fraam.de" = {
        inherit webroot group postRun;
      };
      "matrix.fraam.de" = {
        inherit webroot group postRun;
      };
      "turn.fraam.de" = {
        inherit webroot group postRun;
      };
    };
  };

  users.groups."${group}".members = [ config.services.nginx.user ];

  systemd.services.traefik.serviceConfig.SupplementaryGroups = group;
}
