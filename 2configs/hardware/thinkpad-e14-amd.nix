{ config, lib, pkgs, modulesPath, ... }:

let
  rtw89Src = pkgs.fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtw89";
    rev = "e3ef10e3a6b3a002af800d658efa904e0d30f1a2";
    sha256 = "sha256-y1Chvr2xiC5gIgYGZmLXZXYjetQ3i2ubtNYXD5Sx7H0=";
  };
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./amd.nix
  ];

  nix.maxJobs = 8;

  boot.extraModulePackages = [
    (config.boot.kernelPackages.rtw89.overrideAttrs (oldAttrs: {
      version = "unstable-2022-08-19";
      src = rtw89Src;
    }))

  ];
  hardware.firmware = with pkgs; [
    (rtw89-firmware.overrideAttrs (oldAttrs: {
      version = "unstable-2022-08-19";
      src = rtw89Src;
    }))
  ];
}
