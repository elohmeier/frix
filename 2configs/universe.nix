{
  anon-demo = {
    nets = {
      frixvpn = {
        ip4.addr = "changeme";
        aliases = [
          "anon-demo.frix"
        ];
        wireguard.pubkey = "guMX8+E7WF2gtczNa6/T9xZyVUS5BBDYc9uoAPL8Ilc=";
      };
    };
    borg.pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILrDnmsYmHVYCJdPI6uNI+LNK0hO8SawYYfPWkk2ingr ";
    ssh.pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHOCdzvWlLN4U7sgi9wj6sRu2Hvle1ox3UK9LoKl4ZRT ";
    syncthing.id = "7YNWR2W-GD6YIXP-FC24S5G-7AM2ANT-ATNBTXU-ILL5G37-XYFHTSM-4YFO4QP";
  };

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
