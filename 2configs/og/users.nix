{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ozzy = {
    isNormalUser = true;
    home = "/home/ozzy";
    createHome = true;
    shell = pkgs.fish;
    uid = 1000;
    description = "Oscar Georgy";
    extraGroups = [ "libvirtd" "docker" "wheel" "networkmanager" "video" ]; # Enable ‘sudo’ for the user.
  };
}
