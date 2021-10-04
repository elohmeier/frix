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
    nginx-acme = 10002;
  };
}
