# https://www.youtube.com/watch?v=WiMwVlpD-GU

{ pkgs }:

rec {
  # TODO: add wordlists from https://github.com/NixOS/nixpkgs/pull/104712
  infosec_no_pyenv = with pkgs; [
    amass
    burpsuite-pro
    cewl
    cifs-utils
    creddump
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
    ligolo-ng
    metasploit
    masscan
    nasm-shell
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
    socat
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
