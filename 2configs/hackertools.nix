# https://www.youtube.com/watch?v=WiMwVlpD-GU

{ pkgs }:

rec {
  # TODO: add wordlists from https://github.com/NixOS/nixpkgs/pull/104712
  infosec_no_pyenv = with pkgs; [
    burpsuite-pro
    cewl
    cifs-utils
    crowbar
    davtest
    dig
    enum4linux
    exploitdb
    freerdp
    ghidra-bin
    gobuster
    hash-identifier
    hashcat
    httpserve
    kirbi2hashcat
    john
    lftp
    metasploit
    nbtscanner
    net-snmp
    nfs-utils
    nikto
    openvpn
    polenum
    postgresql # for msfdb
    proxychains
    pwndbg
    samba
    ripgrep
    ripgrep-all
    rlwrap
    snmpcheck
    sqlmap
    sqsh
    sshuttle
    thc-hydra
    wireshark-qt
    wpscan
    zig
  ];

  infosec = infosec_no_pyenv ++ [
    pkgs.frixPython2Env
    pkgs.frixPython3Env
  ];
}
