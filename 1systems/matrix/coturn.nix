{ config, lib, pkgs, ... }:

{
  frix.coturn = {
    enable = true;
    no-cli = true;
    no-tcp-relay = true;
    use-auth-secret = true;
    static-auth-secret-file = config.frix.secrets.turn-shared-secret.path;
    realm = "turn.fraam.de";
    cert = "/var/lib/acme/turn.fraam.de/fullchain.pem";
    pkey = "/var/lib/acme/turn.fraam.de/key.pem";
    listening-ips = [ "49.12.201.141" "2a01:4f8:c0c:1992::1" ];
    relay-ips = [ "49.12.201.141" "2a01:4f8:c0c:1992::1" ];
    extraConfig = ''
      no-multicast-peers
    '';
  };

  frix.secrets.turn-shared-secret = {
    dependants = [ "coturn.service" ];
    owner = "turnserver";
  };

  users.groups.keys.members = [ "turnserver" ];

  networking.firewall.interfaces.ens3 =
    with config.frix.coturn;
    {
      allowedTCPPorts = [ listening-port alt-listening-port ];
      allowedUDPPorts = [ listening-port alt-listening-port ];
      allowedUDPPortRanges = [{ from = min-port; to = max-port; }];
    };
}
