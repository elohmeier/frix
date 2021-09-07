{ lib, pkgs, ... }:

{
  fileSystems."/" =
    {
      device = "/dev/sysVG/root";
      fsType = "ext4";
    };

  fileSystems."/home" =
    {
      device = "/dev/sysVG/home";
      fsType = "ext4";
      options = [ "nodev" "nosuid" ];
    };

  fileSystems."/var" =
    {
      device = "/dev/sysVG/var";
      fsType = "ext4";
      options = [ "nodev" "nosuid" "noexec" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/sysVG/nix";
      fsType = "ext4";
      options = [ "nodev" ];
    };

  swapDevices = [{ device = "/dev/sysVG/swap"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  boot.tmpOnTmpfs = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  hardware = {
    firmware = with pkgs; [
      firmwareLinuxNonfree
    ];

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
}
