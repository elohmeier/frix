{ config, lib, pkgs, ... }:

{
  networking = {
    hostName = "as";
    useNetworkd = true;
    useDHCP = false;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi = {
        backend = "iwd";
        macAddress = "random";
        powersave = true;
      };
    };
    wireless.iwd.enable = true;
  };

  services.resolved = {
    enable = true;
    dnssec = "false";
  };

  # speed up networking
  boot.kernelModules = [ "tcp_bbr" ];
  boot.kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr"; # affects both IPv4 and IPv6r
}
