{ ... }:
{
  # Configure networking
  networking = {
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
}
