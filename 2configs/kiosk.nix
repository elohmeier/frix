{ config, lib, pkgs, ... }:

{
  fileSystems."/home/guest" =
    {
      fsType = "tmpfs";
      options = [
        "nodev"
        "noexec"
        "nosuid"
        "size=1G"
        "mode=0700"
        "uid=1234"
        "gid=1000"
      ];
    };

  users.users.guest = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "video" ];
    initialHashedPassword = "";
    uid = 1234;
  };

  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "guest";
  };

  users.users.root.openssh.authorizedKeys.keys =
    let
      sshkeys = import ./sshkeys.nix;
    in
    [
      sshkeys.enno_yubi41
      sshkeys.enno_yubi49
    ];
}
