{ config, lib, pkgs, ... }:

{
  networking.firewall.interfaces.ens3.allowedTCPPorts = [ 80 443 ];

  # TODO
  #systemd.services.presidio-demo = {
  #
  #  };

  services.traefik = {
    enable = true;

    staticConfigOptions = {
      accessLog = {
        bufferingSize = 100;
        filePath = "/var/lib/traefik/access.log";
      };

      entryPoints = {
        www-http.address = ":80";
        www-https.address = ":443";
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
          anon-demo-plain = {
            entryPoints = [ "www-http" ];
            middlewares = [ "security-headers" "https-redirect" ];
            rule = "Host(`anon-demo.fraam.de`)";
            service = "presidio";
          };

          anon-demo-tls = {
            entryPoints = [ "www-https" ];
            middlewares = [ "security-headers" ];
            rule = "Host(`anon-demo.fraam.de`)";
            service = "presidio";

            tls.certResolver = "letsencrypt";
          };
        };

        services = {
          presidio = {
            loadBalancer = {
              passHostHeader = true;
              servers = [
                { url = "http://localhost:8000"; }
              ];
            };
          };
        };
      };

      tls.options.default = {
        cipherSuites = [ "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384" "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384" "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256" "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256" "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305" "TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305" ];
        minVersion = "VersionTLS12";
        sniStrict = true;
      };
    };

  };







}
