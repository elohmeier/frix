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
  };
}
