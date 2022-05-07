{ config, lib, pkgs, ... }:

let
  settings = {
    server.host = "voice.fraam.de";
    bot.username = "Partiboi69";
    bot.comment = "Music bot";
    bot.max_track_duration = "360";
    bot.volume = "0.5";
    bot.bandwidth = "192000";
    webinterface.enabled = "False";
    # http://www.wefunkradio.com/play/shoutcast.pls
    radio.wefunk = "https://s-14.wefunkradio.com:8443/wefunk64.mp3";
  };
  configFile = (pkgs.formats.ini { }).generate "botamusique.ini" settings;
in
{
  systemd.services.botamusique = {
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    unitConfig.Documentation = "https://github.com/azlux/botamusique/wiki";

    environment.HOME = "/var/lib/botamusique";

    serviceConfig = {
      EnvironmentFile = "/var/src/secrets/botamusique.env";
      ExecStart = "${pkgs.botamusique}/bin/botamusique --config ${configFile} -P $MUMBLE_PASSWORD";
      Restart = "always"; # the bot exits when the server connection is lost

      # Hardening
      CapabilityBoundingSet = [ "" ];
      DynamicUser = true;
      IPAddressDeny = [
        "link-local"
        "multicast"
      ];
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      ProcSubset = "pid";
      PrivateDevices = true;
      PrivateUsers = true;
      PrivateTmp = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
      ];
      StateDirectory = "botamusique";
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
        "~@privileged"
        "~@resources"
      ];
      UMask = "0077";
      WorkingDirectory = "/var/lib/botamusique";
    };
  };
}
