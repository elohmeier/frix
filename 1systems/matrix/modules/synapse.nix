{ config, lib, pkgs, ... }:

let
  serverName = "fraam.de";
  fqdn = "matrix.fraam.de";
in
{
  environment.systemPackages = with pkgs;[ matrix-synapse ];

  services.matrix-synapse = {
    enable = true;

    server_name = serverName;
    public_baseurl = "https://${fqdn}/";

    database_type = "psycopg2";
    database_args.dbname = "synapse";

    listeners = [
      {
        port = config.frix.ports.matrix-synapse;
        bind_address = "127.0.0.1";
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = [
          {
            names = [ "client" "federation" ];
            compress = false;
          }
        ];
      }
    ];

    extraConfig = ''
      enable_set_displayname: false
      enable_set_avatar_url: false
      enable_3pid_changes: false

      auto_join_rooms:
        - "#alle:fraam.de"

      autocreate_auto_join_rooms: true
      autocreate_auto_join_rooms_federated: false

      email:
        smtp_host: smtp-relay.gmail.com
        smtp_port: 587
        enable_tls: true
        notif_from: "fraam chat <matrix@fraam.de>"
        client_base_url: "https://chat.fraam.de/"
        app_name: fraam chat
        enable_notifs: true
      
      password_config:
        enabled: true
        policy:
          enabled: true
          minimum_length: 12

      retention:
        enabled: true
        default_policy:
          min_lifetime: 1d
          max_lifetime: 120d
        purge_jobs:
          - longest_max_lifetime: 3d
            interval: 1d
          - shortest_max_lifetime: 3d
            interval: 1d
      
      federation_domain_whitelist:
        - ${serverName}
        - matrix.org
        - nerdworks.de
    '';

    turn_uris = [
      "turn:turn.fraam.de:3478?transport=udp"
      "turn:turn.fraam.de:3478?transport=tcp"
    ];
    turn_user_lifetime = "1h";

    extraConfigFiles = [
      config.frix.secrets."synapse-oidc.yml".path
      config.frix.secrets."synapse-coturn.yml".path
    ];
  };

  frix.secrets."synapse-coturn.yml" = {
    dependants = [ "matrix-synapse.service" ];
    owner = "matrix-synapse";
  };

  frix.secrets."synapse-oidc.yml" = {
    dependants = [ "matrix-synapse.service" ];
    owner = "matrix-synapse";
  };

  users.groups.keys.members = [ "matrix-synapse" ];
}
