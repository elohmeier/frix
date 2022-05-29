{
  description = "frix fraam nix configs";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-21.11;
    nixpkgs-master.url = github:NixOS/nixpkgs/master;
    home-manager.url = github:nix-community/home-manager/release-21.11;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-master
    , home-manager
    , nixos-hardware
    , flake-utils
    , ...
    }: {

      nixosConfigurations =
        let
          defaultModules = [
            ({ pkgs, ... }:
              let
                pkgs_master = import nixpkgs-master {
                  system = pkgs.system;
                  config.allowUnfree = true;
                };
              in
              {
                nix.nixPath = [
                  "nixpkgs=${nixpkgs}"
                ];
                nixpkgs.config = {
                  allowUnfree = true;
                  packageOverrides = import ./5pkgs pkgs pkgs_master;
                };
              })
          ];
          desktopModules = defaultModules ++ [{
            home-manager.useGlobalPkgs = true;
            nix.nixPath = [ "home-manager=${home-manager}" ];
          }];
        in
        {
          # check config using `nix eval .#nixosConfigurations.as.config.system.build.toplevel.drvPath`
          # build using `nix build .#nixosConfigurations.as.config.system.build.toplevel`
          # switch to config using `nixos-rebuild --flake .#as switch`
          # fresh install using `nixos-install --flake git+https://git.fraam.de/fraam/frix#as`
          as = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = desktopModules ++ [
              home-manager.nixosModule
              ./1systems/as/configuration.nix
            ];
          };

          # build using `nix build .#nixosConfigurations.failbowl.config.system.build.toplevel`
          # switch to config using `nixos-rebuild --flake .#failbowl switch`
          failbowl = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = desktopModules ++ [
              home-manager.nixosModule
              ./1systems/failbowl/configuration.nix
              "${nixos-hardware}/dell/xps/15-7590/default.nix"
            ];
          };

          # check config using `nix eval .#nixosConfigurations.lk.config.system.build.toplevel.drvPath`
          # build using `nix build .#nixosConfigurations.lk.config.system.build.toplevel`
          # switch to config using `nixos-rebuild --flake .#lk switch`
          # fresh install using `nixos-install --flake git+https://git.fraam.de/fraam/frix#lk`
          lk = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = desktopModules ++ [
              home-manager.nixosModule
              ./1systems/lk/configuration.nix
            ];
          };

          # check config using `nix eval .#nixosConfigurations.og-e15.config.system.build.toplevel.drvPath`
          # build using `nix build .#nixosConfigurations.og-e15.config.system.build.toplevel`
          # switch to config using `nixos-rebuild --flake .#og-e15 switch`
          # fresh install using `nixos-install --flake git+https://git.fraam.de/fraam/frix#og-e15`
          og-e15 = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = desktopModules ++ [
              home-manager.nixosModule
              ./1systems/og-e15/configuration.nix
              ./2configs/og/home-manager.nix
            ];
          };

          # check config using `nix eval .#nixosConfigurations.og-g580.config.system.build.toplevel.drvPath`
          # build using `nix build .#nixosConfigurations.og-g580.config.system.build.toplevel`
          # switch to config using `nixos-rebuild --flake .#og-g580 switch`
          og-g580 = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = desktopModules ++ [
              home-manager.nixosModule
              ./1systems/og-g580/configuration.nix
              ./2configs/og/home-manager.nix
            ];
          };

          # fresh install using `nixos-install --flake git+https://git.fraam.de/fraam/frix#og-g580-install`
          og-g580-install = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = desktopModules ++ [
              home-manager.nixosModule
              ./1systems/og-g580/configuration.nix
            ];
          };

          # switch remote host to configuration using `nixos-rebuild --flake .#anon-demo --target-host root@anon-demo.fraam.de --build-host localhost switch`
          anon-demo = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              ./1systems/anon-demo/configuration.nix
            ];
          };

          # check config using `nix eval .#nixosConfigurations.metrics.config.system.build.toplevel.drvPath`
          # build using `nix build .#nixosConfigurations.metrics.config.system.build.toplevel`
          # switch remote host to configuration using `nixos-rebuild --flake .#metrics --target-host root@metrics.fraam.de --build-host localhost switch`
          metrics = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              ./1systems/metrics/configuration.nix
            ];
          };

          # fresh install using `nixos-install --flake git+https://git.fraam.de/fraam/frix#matrix --no-root-passwd --no-channel-copy`
          matrix = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              ./1systems/matrix/configuration.nix
            ];
          };

          telefonbuch = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              ./1systems/telefonbuch/configuration.nix
            ];
          };

          wv = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = desktopModules ++ [
              home-manager.nixosModule
              ./1systems/wv/configuration.nix
            ];
          };

          wv-hyperv = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = desktopModules ++ [
              home-manager.nixosModule
              ./1systems/wv-hyperv/configuration.nix
            ];
          };

          # generate iso using `nix build .#nixosConfigurations.iso.config.system.build.isoImage`
          # test build using `nix build .#nixosConfigurations.iso.config.system.build.toplevel`
          iso = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = defaultModules ++ [
              #"${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
              "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma5.nix"
              ./.
              ({ config, pkgs, ... }: {
                console.keyMap = "de-latin1";
                services.xserver.layout = "de";
                i18n.defaultLocale = "de_DE.UTF-8";
                time.timeZone = "Europe/Berlin";
                hardware.enableAllFirmware = true;
                boot.extraModulePackages = [ config.boot.kernelPackages.rtw89 ]; # ThinkPad E14
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
                #   Passphrase=
                #   EOF
                # '';

                nix = {
                  package = pkgs.nixFlakes;
                  extraOptions = "experimental-features = nix-command flakes";
                };

                environment.systemPackages = with pkgs; [ firefox btop gitMinimal ];
              })
            ];
          };
        };
    } //
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs_master = import nixpkgs-master { inherit system; };
        packages = import nixpkgs {
          config.allowUnfree = true; inherit system;
          config.packageOverrides = import ./5pkgs packages pkgs_master;
        };
        devShell = packages.mkShell {
          buildInputs = with packages; [ hackertools ];
          SECLISTS = "${packages.wordlists-seclists}/share/wordlists/SecLists";
        };
      in
      { inherit packages devShell; });
}
