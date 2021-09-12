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
}
