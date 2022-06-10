/*

  Default config for hetzner cloud virtual machines.
  --------------------------------------------------

  Prepare the disk when installing using:

  sgdisk -og -a1 -n1:2048:+200M -t1:8300 -n3:-1M:0 -t3:EF02 -n2:0:0 -t2:8300 /dev/sda
  pvcreate /dev/sda2
  vgcreate sysVG /dev/sda2
  lvcreate -L 1G -n root sysVG
  lvcreate -L 6G -n nix sysVG
  lvcreate -L 2G -n var sysVG
  lvcreate -L 4G -n swap sysVG
  mkfs.ext4 -F /dev/sysVG/root
  mkfs.ext4 -F /dev/sysVG/nix
  mkfs.ext4 -F /dev/sysVG/var
  mkfs.ext4 -F /dev/sda1
  mkswap /dev/sysVG/swap
  mount /dev/sysVG/root /mnt/
  mkdir /mnt/{boot,nix,var}
  mount /dev/sda1 /mnt/boot
  mount /dev/sysVG/nix /mnt/nix
  mount /dev/sysVG/var /mnt/var

*/

{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")

      ./admintools.nix
      ./fish.nix
    ];

  boot.tmpOnTmpfs = true;
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  boot.initrd = {
    availableKernelModules =
      [ "ata_piix" "uhci_hcd" "virtio_net" "virtio_pci" "sd_mod" "sr_mod" ];
  };

  fileSystems."/" =
    {
      device = "/dev/sysVG/root";
      fsType = "ext4";
      options = [ "nodev" "nosuid" "noexec" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/sysVG/nix";
      fsType = "ext4";
      options = [ "nodev" ];
    };

  fileSystems."/var" =
    {
      device = "/dev/sysVG/var";
      fsType = "ext4";
      options = [ "nodev" "nosuid" "noexec" ];
      neededForBoot = true; # needed to set user passwords from /var/src/secrets
    };

  fileSystems."/boot" =
    {
      device = "/dev/sda1";
      fsType = "ext4";
      options = [ "nodev" "nosuid" "noexec" ];
    };

  swapDevices = [
    { device = "/dev/sysVG/swap"; }
  ];

  nix = {
    gc = {
      automatic = lib.mkDefault true;
      options = "-d";
    };
    maxJobs = lib.mkDefault 4;
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  networking = {
    useNetworkd = true;
    useDHCP = false;
    firewall.logRefusedConnections = false;
  };

  systemd.network.networks."40-en" = {
    matchConfig.Name = "en*";
    networkConfig = {
      DHCP = "yes";
      IPv6PrivacyExtensions = "kernel";
    };

    # prevents creation of the following route (`ip -6 route`):
    # default dev lo proto static metric 1024 pref medium
    routes = [{ routeConfig = { Gateway = "fe80::1"; }; }];
  };

  services.resolved.llmnr = "false"; # only useful in LANs

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "prohibit-password";
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
  };

  users.mutableUsers = false;
  users.users.root.passwordFile = "/var/src/secrets/root.passwd";

  # save space
  environment.noXlibs = true;
  documentation.enable = false;
  documentation.nixos.enable = false;
  environment.defaultPackages = [
    pkgs.rsync # required for frix-copy-secrets
  ];
  services.udisks2.enable = false;
}
