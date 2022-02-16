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
        powersave = false;
      };
    };
    wireless.iwd.enable = true;
  };

  services.resolved = {
    enable = true;
    dnssec = "false";
  };
}
