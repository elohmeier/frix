{ config, lib, pkgs, ... }:

{
  imports = [
    ../../2configs/wv.nix
    ../../2configs/standard-filesystems.nix
  ];

  virtualisation.hypervGuest = {
    enable = true;
    videoMode = "1920x1080";
  };

  boot.kernelModules = [ "hv_sock" ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      device = "/dev/sda";
      efiSupport = true;
    };
  };

  services.xserver = {
    modules = [ pkgs.xorg.xf86videofbdev ];
    videoDrivers = [ "hyperv_fb" ];
  };

  services.xrdp = {
    enable = true;
    defaultWindowManager = toString config.services.xserver.displayManager.sessionData.wrapper;
    package = pkgs.xrdp.overrideAttrs (old: rec {
      configureFlags = old.configureFlags ++ [ " --enable-vsock" ];

      postInstall = old.postInstall + ''
        ${pkgs.gnused}/bin/sed -i -e 's!use_vsock=false!use_vsock=true!g'                               $out/etc/xrdp/xrdp.ini
        ${pkgs.gnused}/bin/sed -i -e 's!security_layer=negotiate!security_layer=rdp!g'                  $out/etc/xrdp/xrdp.ini
        ${pkgs.gnused}/bin/sed -i -e 's!crypt_level=high!crypt_level=none!g'                            $out/etc/xrdp/xrdp.ini
        ${pkgs.gnused}/bin/sed -i -e 's!bitmap_compression=true!bitmap_compression=false!g'             $out/etc/xrdp/xrdp.ini
        ${pkgs.gnused}/bin/sed -i -e 's!FuseMountName=thinclient_drives!FuseMountName=shared-drives!g'    $out/etc/xrdp/sesman.ini
      '';
    });
  };

  environment.etc."X11/Xwrapper.config" = {
    mode = "0644";
    text = ''
      allowed_users=anybody
      needs_root_rights=yes
    '';
  };

  security.pam.services.xrdp-sesman-rdp = {
    text = ''
      auth      include   system-remote-login
      account   include   system-remote-login
      password  include   system-remote-login
      session   include   system-remote-login
    '';
  };

  security.polkit = {
    enable = true;
    extraConfig = ''
          polkit.addRule(function(action, subject) {
          if ((action.id == "org.freedesktop.color-manager.create-device" ||
          action.id == "org.freedesktop.color-manager.modify-profile" ||
          action.id == "org.freedesktop.color-manager.delete-device" ||
          action.id == "org.freedesktop.color-manager.create-profile" ||
          action.id == "org.freedesktop.color-manager.modify-profile" ||
          action.id == "org.freedesktop.color-manager.delete-profile") &&
          subject.isInGroup("users")) {
          return polkit.Result.YES;
      }
      });
    '';
  };


  nix.maxJobs = 4;
}
