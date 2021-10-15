{ config, lib, pkgs, ... }: {

  services.loki = {
    enable = true;
    configuration = {
      server.http_listen_port = config.frix.ports.loki;
      auth_enabled = false; # single-tenant mode, see https://grafana.com/docs/loki/latest/operations/multi-tenancy/
      schema_config = {
        configs = [
          {
            from = "2021-01-01";
            store = "boltdb-shipper";
            object_store = "filesystem";
            schema = "v11";
            index.prefix = "index_";
            index.period = "24h";
          }
        ];
      };
      storage_config = {
        boltdb_shipper = {
          active_index_directory = "/var/lib/loki/boltdb-shipper/active";
          cache_location = "/var/lib/loki/boltdb-shipper/cache";
          cache_ttl = "24h";
          shared_store = "filesystem";

        };
        filesystem = {
          directory = "/var/lib/loki/chunks";
        };
      };

      ingester = {
        lifecycler = {
          interface_names = [ "lo" ];
          address = "127.0.0.1";

          ring = {
            kvstore = {
              store = "inmemory";
            };
            replication_factor = 1;
          };
          final_sleep = "0s";
        };
        chunk_idle_period = "5m";
        chunk_retain_period = "30s";
      };
      compactor = {
        shared_store = "filesystem";
        compaction_interval = "10m";
        working_directory = "/var/lib/loki/compactor";
      };
    };
  };
}
