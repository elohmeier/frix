{ config, lib, pkgs, ... }:

{
  networking.firewall.interfaces.ens3.allowedTCPPorts = [ 80 443 ];

  services.traefik = {
    enable = true;

    staticConfigOptions = {
      accessLog = {
        bufferingSize = 100;
        filePath = "/var/lib/traefik/access.log.json";
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
        matrix-federation.address = ":8448";
      };

      global = {
        checkNewVersion = false;
        sendAnonymousUsage = false;
      };

      log.level = "WARN";

      certificatesResolvers.letsencrypt.acme = {
        email = "enno.richter+acme@fraam.de";
        storage = "/var/lib/traefik/acme.json";
        httpChallenge.entryPoint = "www-http";
      };
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
        };

        routers = {
          chat-plain = {
            entryPoints = [ "www-http" ];
            middlewares = [ "security-headers" "https-redirect" ];
            rule = "Host(`chat.fraam.de`)";
            service = "element";
          };

          chat-tls = {
            entryPoints = [ "www-https" ];
            middlewares = [ "security-headers" ];
            rule = "Host(`chat.fraam.de`)";
            service = "element";
            tls.certResolver = "letsencrypt";
          };

          matrix-plain = {
            entryPoints = [ "www-http" ];
            middlewares = [ "security-headers" "https-redirect" ];
            rule = "Host(`matrix.fraam.de`)";
            service = "synapse";
          };

          matrix-tls = {
            entryPoints = [ "www-https" "matrix-federation" ];
            middlewares = [ "security-headers" ];
            rule = "Host(`matrix.fraam.de`)";
            service = "synapse";
            tls.certResolver = "letsencrypt";
          };
        };

        services = {
          element = {
            loadBalancer = {
              passHostHeader = true;
              servers = [
                { url = "http://127.0.0.1:4711"; }
              ];
            };
          };

          synapse = {
            loadBalancer = {
              passHostHeader = true;
              servers = [
                { url = "http://127.0.0.1:8008"; }
              ];
            };
          };
        };
      };

      tls.options.default = {
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
    };

  };

  frix.logrotate.config = ''
    /var/log/traefik/*.log.json {
      daily
      rotate 7
      missingok
      notifempty
      compress
      dateext
      dateformat .%Y-%m-%d
      postrotate
        systemctl kill -s USR1 traefik.service
      endscript
    }
  '';
}
