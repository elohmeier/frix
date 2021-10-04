{ config, lib, ... }:

with lib;
{
  options.frix.ports = mkOption
    {
      internal = true;
      type = with types;attrsOf int;
    };

  config.frix.ports = {
    grafana = 10001;
    loki = 10002;
    nginx-acme = 10003;
    node-exporter = 10004;
    prometheus = 10005;
  };
}
