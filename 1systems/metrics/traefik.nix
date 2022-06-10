{ config, lib, pkgs, ... }:

{
  networking.firewall.interfaces.enp1s0.allowedTCPPorts = [ 80 443 8734 ];

  services.traefik = {
    enable = true;

    staticConfigOptions = {
      accessLog = {
        bufferingSize = 100;
        filePath = "/var/log/traefik/access.log.json";
        format = "json";
        fields = {
          defaultMode = "keep";
          headers = {
            defaultMode = "keep";
          };
        };
      };

      entryPoints = {
        www-http.address = ":80";
        www-https.address = ":443";
        loki-https.address = ":8734";
      };

      global = {
        checkNewVersion = false;
        sendAnonymousUsage = false;
      };

      log.level = "WARN";
    };

    dynamicConfigOptions = {
      http = {
        middlewares = {
          https-redirect.redirectScheme = {
            permanent = true;
            scheme = "https";
          };

          security-headers.headers = {
            STSPreload = true;
            STSSeconds = 315360000;
            browserXSSFilter = true;
            contentSecurityPolicy = ''"frame-ancestors 'self' https://*.fraam.de"'';
            contentTypeNosniff = true;
            customFrameOptionsValue = "sameorigin";
            referrerPolicy = "strict-origin";
          };

          metrics-auth.basicAuth = {
            usersFile = "/run/credentials/traefik.service/metrics-auth.htpasswd";
            realm = "metrics";
          };
        };

        routers = {
          http-plain = {
            entryPoints = [ "www-http" ];
            middlewares = [ "security-headers" "https-redirect" ];
            rule = "Host(`metrics.fraam.de`)";
            service = "grafana";
          };

          https-tls = {
            entryPoints = [ "www-https" ];
            middlewares = [ "security-headers" ];
            rule = "Host(`metrics.fraam.de`)";
            service = "grafana";
            tls = { };
          };

          loki-tls = {
            entryPoints = [ "loki-https" ];
            middlewares = [ "metrics-auth" ];
            rule = "Host(`metrics.fraam.de`)";
            service = "loki";
            tls = { };
          };

          acme = {
            entryPoints = [ "www-http" ];
            rule = "PathPrefix(`/.well-known/acme-challenge`)";
            priority = 9999;
            service = "nginx-acme";
          };
        };

        services = {

          nginx-acme = {
            loadBalancer = {
              passHostHeader = true;
              servers = [
                { url = "http://127.0.0.1:${toString config.frix.ports.nginx-acme}"; }
              ];
            };
          };

          grafana = {
            loadBalancer = {
              passHostHeader = true;
              servers = [
                { url = "http://127.0.0.1:${toString config.frix.ports.grafana}"; }
              ];
            };
          };

          loki = {
            loadBalancer = {
              passHostHeader = true;
              servers = [
                { url = "http://127.0.0.1:${toString config.frix.ports.loki}"; }
              ];
            };
          };
        };
      };

      tls = {
        options.default = {
          cipherSuites = [
            "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384"
            "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
            "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
            "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
            "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305"
            "TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305"
          ];
          minVersion = "VersionTLS12";
          sniStrict = true;
        };

        stores.default = { };

        certificates =
          map
            (
              domain: {
                certFile = "/var/lib/acme/${domain}/fullchain.pem";
                keyFile = "/var/lib/acme/${domain}/key.pem";
                stores = [ "default" ];
              }
            )
            [ "metrics.fraam.de" ];
      };
    };

  };

  services.logrotate.settings."/var/log/traefik/*.log.json" = {
    daily = "";
    rotate = 7;
    missingok = "";
    notifempty = "";
    compress = "";
    dateext = "";
    dateformat = ".%Y-%m-%d";
    postrotate = "systemctl kill -s USR1 traefik.service";
  };

  systemd.services.traefik.serviceConfig.LoadCredential = "metrics-auth.htpasswd:/var/src/secrets/metrics-auth.htpasswd";
}
