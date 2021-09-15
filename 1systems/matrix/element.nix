{ pkgs, ... }:

{
  services.nginx = {
    enable = true;
    virtualHosts = {
      "fraam-intweb" = {
        listen = [{
          addr = "127.0.0.1";
          port = 4711;
        }];

        root = pkgs.element-web.override {
          conf = {
            default_server_config."m.homeserver" = {
              base_url = "https://matrix.fraam.de";
              server_name = "fraam.de";
            };
            sso_immediate_redirect = true;
            defaultCountryCode = "DE";
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
