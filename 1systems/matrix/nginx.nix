{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;
    commonHttpConfig = ''
      charset UTF-8;
      types_hash_max_size 4096;
      server_names_hash_bucket_size 128;
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

      "element-web" = {
        listen = [{
          addr = "127.0.0.1";
          port = config.frix.ports.element-web;
        }];

        root = pkgs.element-web.override {
          conf = {
            default_server_config."m.homeserver" = {
              base_url = "https://matrix.fraam.de";
              server_name = "fraam.de";
            };
            sso_immediate_redirect = true;
            defaultCountryCode = "DE";
            default_federate = false;
            brand = "fraam chat";
            roomDirectory.servers = [ ];
          };
        };

        extraConfig = ''
          access_log off;
        '';
      };
    };
  };
}
