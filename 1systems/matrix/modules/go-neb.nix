{ config, lib, pkgs, ... }:

{
  services.go-neb = {
    enable = true;
    secretFile = "/var/src/secrets/go-neb.env";
    bindAddress = "0.0.0.0:${toString config.frix.ports.go-neb}";
    baseUrl = "http://matrix.pug-coho.ts.net:4050";

    # use `https matrix.fraam.de/_matrix/client/r0/login identifier[type]=m.id.user identifier[user]=<<USERNAME>> password=<<PASSWORD>> type=m.login.password` to get a token
    config = {
      clients = [
        {
          UserID = "@alertmanager-bot:fraam.de";
          AccessToken = "$ALERTMANAGER_BOT_ACCESS_TOKEN";
          DeviceID = "$ALERTMANAGER_BOT_DEVICE_ID";
          HomeserverURL = "https://matrix.fraam.de";
          Sync = true;
          AutoJoinRooms = true;
          DisplayName = "alertmanager-bot";
          AcceptVerificationFromUsers = [ ":fraam.de" ];
        }
        {
          UserID = "@pm-bot:fraam.de";
          AccessToken = "$PM_BOT_ACCESS_TOKEN";
          DeviceID = "$PM_BOT_DEVICE_ID";
          HomeserverURL = "https://matrix.fraam.de";
          Sync = true;
          AutoJoinRooms = true;
          DisplayName = "pm-bot";
          AcceptVerificationFromUsers = [ ":fraam.de" ];
        }
      ];

      services = [
        {
          ID = "alertmanager_service";
          Type = "alertmanager";
          UserID = "@alertmanager-bot:fraam.de";
          Config = {
            webhook_url = "http://matrix.pug-coho.ts.net:4050/services/hooks/YWxlcnRtYW5hZ2VyX3NlcnZpY2U";
            rooms = {
              # Enno
              "!ITyZhYetpXJHZTcgtl:fraam.de" = {
                text_template = "{{range .Alerts -}} [{{ .Status }}] {{index .Labels \"alertname\" }}: {{index .Annotations \"description\"}} {{ end -}}";
                # html_template = ''
		# TODO
                # '';
                msg_type = "m.text";
              };
            };
          };
        }

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
