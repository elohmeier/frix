{ config, lib, pkgs, ... }:

{
  networking = {
    useNetworkd = true;
    useDHCP = false;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi = {
        backend = "iwd";
        macAddress = "random";
        powersave = false;
      };
    };
    wireless.iwd.enable = true;
  };

  services.resolved = {
    enable = true;
    dnssec = lib.mkDefault "false";
  };

  # speed up networking
  boot.kernelModules = [ "tcp_bbr" ];
  boot.kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr"; # affects both IPv4 and IPv6r
}
