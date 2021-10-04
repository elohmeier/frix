{
  matrix = {
    nets = {
      frixvpn = {
        ip4.addr = "changeme";
        aliases = [
          "matrix.frix"
        ];
        wireguard.pubkey = "MYKAeKtwqzLbg42qQ6rzrGLO5jCtcR+wYIPm5njmlVI=";
      };
    };
    borg.pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILM7n6NUSAQSKeKsv9ZlTSWh1tEEoFWpYU/L7C+oQFCz ";
    ssh.pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA1vfDnfwil0H/H0ihe+kKviKfaPn7umDH1nCTen0WDE ";
    syncthing.id = "IL7I4UQ-225A3ZE-IK3GYVF-KKYR43B-275FCGF-WM2R5JK-MBJAFIA-PEREVAA";
  };

  metrics = {
    nets = {
      frixvpn = {
        ip4.addr = "changeme";
        aliases = [
          "metrics.frix"
        ];
        wireguard.pubkey = "NM1KZJ1FTyGfG0KShJtwkLEdF7IFFaMN/dxAhLQrlXE=";
      };
    };
    borg.pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYuPvHZjjHJabtM7BR7HaWxxaf1rRE6Vx1AsSs2BNEa ";
    ssh.pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAcLeH0faEOzfBKnX6pEWvK2cK9aEqtR6Cdx4RKDlDW7 ";
    syncthing.id = "PIS5EMU-E5ZJQXL-ZTNLADX-AOWPOA2-XOZFWIL-NZ2TVPE-FNLQ7QT-J2KXAQ3";
  };
}
