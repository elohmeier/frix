{ pkgs, ... }:

{
  imports = [
    ../plasma-desktop
    ../standard-filesystems.nix

    ./lampp.nix
    ./packages.nix
    ./virtualisation.nix
  ];

  hardware.firmware = with pkgs; [ firmwareLinuxNonfree ];

  users.users.mainUser = {
    name = "ozzy";
    home = "/home/ozzy";
    description = "Oscar Georgy";
  };

  services.xserver.windowManager.i3.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
