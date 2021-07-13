{
  description = "frix fraam nix configs";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-21.05;
    home-manager.url = github:nix-community/home-manager/release-21.05;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }: {

    nixosConfigurations =
      let
        defaultModules = [{
          nix.nixPath = [
            "home-manager=${home-manager}"
            "nixpkgs=${nixpkgs}"
          ];
        }];
      in
      {

        # build using `nix build .#nixosConfigurations.failbowl.config.system.build.toplevel`
        # switch to config using `nixos-rebuild --flake .#failbowl switch`
        failbowl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = defaultModules ++ [
            home-manager.nixosModule
            ./1systems/failbowl/configuration.nix
            "${nixos-hardware}/dell/xps/15-7590/default.nix"
          ];
        };

        # generate iso using `nix build .#nixosConfigurations.iso.config.system.build.isoImage`
        # test build using `nix build .#nixosConfigurations.iso.config.system.build.toplevel`
        iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            #"${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma5.nix"
            ./.
            ./2configs/hackertools.nix
            {
              console.keyMap = "de-latin1";
              services.xserver.layout = "de";
              i18n.defaultLocale = "de_DE.UTF-8";
              time.timeZone = "Europe/Berlin";
              networking = {
                useNetworkd = true;
                useDHCP = false;
                wireless.enable = false;
                wireless.iwd.enable = true;
                interfaces.wlan0.useDHCP = true;
                networkmanager.wifi.backend = "iwd";
              };
              # system.activationScripts.configure-iwd = nixpkgs.lib.stringAfter [ "users" "groups" ] ''
              #   mkdir -p /var/lib/iwd
              #   cat >/var/lib/iwd/fraam.psk <<EOF
              #   [Security]
              #   PreSharedKey=
              #   Passphrase=
              #   EOF
              # '';
              environment.systemPackages =
                let
                  pkgs = import
                    nixpkgs
                    {
                      config.allowUnfree = true;
                      system = "x86_64-linux";
                    };
                in
                [ pkgs.vivaldi ];
            }
          ];
        };
      };




  };
}
