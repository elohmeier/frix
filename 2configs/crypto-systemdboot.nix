{ config, lib, pkgs, ... }:

{
  boot = {
    initrd.luks.devices.crypto.device = lib.mkDefault "/dev/disk/by-partlabel/crypto";
    loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi.canTouchEfiVariables = lib.mkDefault true;
    };
  };
}
