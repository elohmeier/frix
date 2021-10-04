{ config, lib, pkgs, ... }:

{
  services.prometheus = {
    enable = true;

    listenAddress = "127.0.0.1";
    port = config.frix.ports.prometheus;

    globalConfig = {
      scrape_interval = "30s";
    };

    exporters = {
      node = {
        enable = true;
        listenAddress = "127.0.0.1";
        port = config.frix.ports.node-exporter;
        enabledCollectors = [
          "cpu"
          "conntrack"
          "diskstats"
          "entropy"
          "filefd"
          "filesystem"
          "loadavg"
          "mdadm"
          "meminfo"
          "netdev"
          "netstat"
          "stat"
          "time"
          "vmstat"
          "systemd"
          "logind"
          "interrupts"
          "ksmd"
          "textfile"
        ];
      };
    };

    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.frix.ports.node-exporter}" ];
        }];
      }
    ];
  };
}
