{ config, lib, pkgs, ... }:

{
  services.go-neb = {
    enable = true;
    secretFile = "/var/src/secrets/go-neb.env";
    bindAddress = "127.0.0.1:${toString config.frix.ports.go-neb}";
    baseUrl = "https://matrix.fraam.de:4050";

    config = {
      clients = [{
        UserID = "@pm-bot:fraam.de";
        AccessToken = "$PM_BOT_ACCESS_TOKEN";
        DeviceID = "$PM_BOT_DEVICE_ID";
        HomeserverURL = "https://matrix.fraam.de";
        Sync = true;
        AutoJoinRooms = true;
        DisplayName = "pm-bot";
        AcceptVerificationFromUsers = [ ":fraam.de" ];
      }];

      services = [
        {
          ID = "kanboard_service";
          Type = "kanboard";
          UserID = "@pm-bot:fraam.de";
          Config = {
            endpoint = "https://pm.fraam.de/";
            username = "jsonrpc";
            password = "$KANBOARD_PASSWORD";
          };
        }

        {
          ID = "kanboard_webhook_service";
          Type = "kanboard-webhook";
          UserID = "@pm-bot:fraam.de";
          Config = {
            endpoint = "https://pm.fraam.de/";
            Rooms = {
              # backoffice
              "!SewNWMMciJPVfEdVKw:fraam.de".Projects."4".Events = [ "task.move.column" "task.assignee_change" "task.create" "comment.create" ];

              # gf
              "!ZwtLCTHgcKbhOpIxOz:fraam.de".Projects."6".Events = [ "task.move.column" "task.assignee_change" "task.create" "comment.create" ];
            };
          };
        }
      ];
    };
  };

}
