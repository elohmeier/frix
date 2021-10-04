{ config, lib, pkgs, ... }:

let
  parserConf = pkgs.writeText "parsers.conf" ''
    [PARSER]
      name traefik
      format json
      time_key time
      time_format %Y-%m-%dT%H:%M:%S%z
      decode_field_as escaped json
  '';

  fluentConf = pkgs.writeText "fluent.conf" ''
    [SERVICE]
      flush 5
      daemon off
      log_Level info
      parsers_file ${parserConf}

    [INPUT]
      name tail
      path /var/log/traefik/access.log.json

    [FILTER]
      name parser
      parser traefik
      match *
      key_name log

    [OUTPUT]
      name loki
      match *
      host metrics.fraam.de
      port 8734
      labels job=fluent-bit
      http_user ''${METRICS_HTTP_USERNAME}
      http_passwd ''${METRICS_HTTP_PASSWORD}
      tls on
  '';
in
{
  systemd.services.fluent-bit = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "Fluent Bit log processor and forwarder";
    serviceConfig = {
      DynamicUser = true;
      ExecStart = "${pkgs.fluent-bit}/bin/fluent-bit --config=${fluentConf}";
      EnvironmentFile = config.frix.secrets."fluent-bit.env".path;
      SupplementaryGroups = "keys traefik";
    };
  };

  environment.systemPackages = [ pkgs.fluent-bit ];

  frix.secrets."fluent-bit.env" = {
    dependants = [ "fluent-bit.service" ];
  };
}
