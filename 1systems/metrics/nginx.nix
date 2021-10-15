{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;
    commonHttpConfig = ''
      charset UTF-8;
      port_in_redirect off;
    '';

    virtualHosts = {
      "acme" = {
        listen = [
          {
            addr = "127.0.0.1";
            port = config.frix.ports.nginx-acme;
          }
        ];

        locations."/.well-known/acme-challenge" = {
          root = "/var/lib/acme/acme-challenge";
        };
      };
    };
  };
}
