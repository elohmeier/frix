{ config, lib, pkgs, ... }:

let
  webroot = "/var/lib/acme/acme-challenge";
  group = "certs";
in
{
  security.acme = {
    defaults.email = "enno.richter+acme@fraam.de";
    acceptTerms = true;
    certs = {
      "chat.fraam.de" = {
        inherit webroot group;
        postRun = "systemctl restart traefik.service";
      };
      "matrix.fraam.de" = {
        inherit webroot group;
        postRun = "systemctl restart traefik.service";
      };
      "turn.fraam.de" = {
        inherit webroot group;
        postRun = "systemctl restart coturn.service";
      };
    };
  };

  users.groups."${group}".members = [
    config.services.nginx.user
    "traefik"
    "turnserver"
  ];
}
