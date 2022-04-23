{ config, lib, pkgs, ... }:

let
  repo = "ssh://u276121-sub1@u276121.your-storagebox.de:23/./borg";
  passCmd = "cat /var/src/secrets/borgbackup.borgkey";
  paths = [
    "/var/backup"
    "/var/lib/acme"
    "/var/lib/matrix-synapse"
    "/var/src/secrets"
  ];
  environment.BORG_BASE_DIR = "/var/lib/borg";
  readWritePaths = [ "/var/lib/borg" ];
  encryption = {
    mode = "repokey";
    passCommand = passCmd;
  };
  compression = "auto,lzma,6";
  extraCreateArgs = "--stats --exclude-caches";
  prune.keep = {
    within = "1d"; # Keep all archives from the last day
    daily = 7;
    weekly = 4;
    monthly = 6;
  };
in
{
  frix.secrets."borgbackup.id_ed25519".path = "/root/.ssh/id_ed25519";

  environment.variables = {
    BORG_BASE_DIR = "/var/lib/borg";
    BORG_REPO = repo;
    BORG_PASSCOMMAND = passCmd;
  };

  services.postgresqlBackup = {
    enable = true;
    backupAll = true;
  };

  services.borgbackup.jobs.hetzner = {
    inherit paths environment readWritePaths encryption compression extraCreateArgs prune;
    repo = repo;
    doInit = false;
    startAt = "*-*-* 03:15:00";
  };
  systemd.services.borgbackup-job-hetzner.serviceConfig.StateDirectory = "borg";
}
