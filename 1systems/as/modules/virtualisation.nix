{ config, pkgs, ... }:

let
  virshNatIpPrefix = "192.168.197"; # "XXX.XXX.XXX" without last block
  virshNatIf = "virsh-nat";
in
{

  virtualisation = {
    # docker = {
    #   enable = true;
    #   enableOnBoot = false; # will be socket-activated
    # };
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
      };
    };
    # spiceUSBRedirection.enable = true;
  };

  # services.samba = {
  #   enable = true;
  #   securityType = "user";
  #   extraConfig = ''
  #     workgroup = WORKGROUP
  #     server string = ${config.networking.hostName}
  #     netbios name = ${config.networking.hostName}
  #     hosts allow = ${virshNatIpPrefix}.0/24 # virshNat network
  #     hosts deny = 0.0.0.0/0
  #   '';
  #   shares = {
  #     home = {
  #       path = "/home/ad";
  #       browseable = "yes";
  #       "read only" = "no";
  #       "guest ok" = "no";
  #     };
  #   };
  # };

  # environment.systemPackages = with pkgs; [
  #   samba
  # ];

  networking = {
    useNetworkd = true;

    firewall.interfaces = {
      "${virshNatIf}" = {
        allowedTCPPorts = [ 53 631 445 139 ];
        allowedUDPPorts = [ 53 67 68 546 547 137 138 ];
      };
    };

    nat = {
      enable = true;
      internalInterfaces = [ virshNatIf ];
      externalInterface = "wlan0";
    };
  };

  systemd.network = {
    netdevs = {
      "40-${virshNatIf}" = {
        netdevConfig = {
          Name = virshNatIf;
          Kind = "bridge";
        };
      };
    };
    networks = {
      "40-${virshNatIf}" = {
        matchConfig.Name = virshNatIf;
        networkConfig = {
          ConfigureWithoutCarrier = true;
          DHCPServer = true;
          Address = "${virshNatIpPrefix}.1/24";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    virtviewer
    virtmanager
  ];

}
