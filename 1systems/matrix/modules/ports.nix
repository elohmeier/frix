{ config, lib, ... }:

with lib;
{
  options.frix.ports = mkOption
    {
      internal = true;
      type = with types;attrsOf int;
    };

  config.frix.ports = {
    coturn = 10001;
    element-web = 10002;
    go-neb = 4050;
    matrix-synapse = 10003;
    nginx-acme = 10004;
  };
}
