{ config, lib, pkgs, ... }:

{
  services.grafana = {
    enable = true;
    port = config.frix.ports.grafana;
    domain = "metrics.fraam.de";
    rootUrl = "https://metrics.fraam.de";
    security = {
      adminPasswordFile = config.frix.secrets.grafana-admin-password.path;
      secretKeyFile = config.frix.secrets.grafana-secret-key.path;
    };

    smtp = {
      enable = false;
    };

    auth = {
      google = {
        enable = true;
        allowSignUp = true;
        clientId = "246785792228-v78io407cle6rr8pmg465lp2epqr22c0.apps.googleusercontent.com";
        clientSecretFile = config.frix.secrets.grafana-google-client-secret.path;
      };
    };

    provision = {
      enable = true;
      datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://localhost:${toString config.frix.ports.prometheus}";
          isDefault = true;
        }
        {
          name = "Loki";
          type = "loki";
          url = "http://localhost:${toString config.frix.ports.loki}";
        }
      ];
    };

    analytics.reporting.enable = false;
  };

  frix.secrets =
    let
      opts = {
        dependants = [ "grafana.service" ];
        owner = "grafana";
      };
    in
    {
      grafana-admin-password = opts;
      grafana-google-client-secret = opts;
      grafana-secret-key = opts;
    };

  systemd.services.grafana.serviceConfig.SupplementaryGroups = "keys";
}
