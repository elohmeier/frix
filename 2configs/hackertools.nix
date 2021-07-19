# https://www.youtube.com/watch?v=WiMwVlpD-GU

{ pkgs }:

let
  py3env = pkgs.python3.withPackages (
    pythonPackages: with pythonPackages; [
      authlib
      beautifulsoup4
      black
      isort
      jupyterlab
      keyring
      lxml
      mypy
      nbconvert
      pandas
      pdfminer
      pillow
      pytest
      requests
      selenium
      tabulate
      termcolor
      weasyprint
    ]
  );

  py2 = pkgs.python2.override {
    packageOverrides = self: super: rec {
      certifi = super.buildPythonPackage rec {
        pname = "certifi";
        version = "2020.04.05.1"; # last version with python2 support
        src = pkgs.fetchFromGitHub {
          owner = pname;
          repo = "python-certifi";
          rev = version;
          sha256 = "sha256-scdb86Bg5tTUDwm5OZ8HXar7VCNlbPMtt4ZzGu/2O4w=";
        };
      };
    };
  };

  py2env = py2.withPackages (pythonPackages: with pythonPackages; [
    impacket
    pycrypto
    requests
  ]);

  # exploitdb not yet in 21.05, take from master/2021-07-14
  exploitdb_master = with import
    (fetchTarball {
      url = https://github.com/NixOS/nixpkgs/archive/c255408808e7bb2091b3f1954ae63519d6b427ef.tar.gz;
      sha256 = "sha256:0i82mw38c029fgw520wzf5v5akswc2r67rxmkgw8c8lx2di7il80";
    })
    { system = pkgs.system; }; exploitdb;
in
{
  # TODO: add wordlists from https://github.com/NixOS/nixpkgs/pull/104712
  infosec = with pkgs; [
    burpsuite-pro
    cewl
    cifs-utils
    davtest
    dig
    exploitdb_master
    freerdp
    ghidra-bin
    gobuster
    hash-identifier
    hashcat
    httpserve
    john
    lftp
    metasploit
    nbtscanner
    net-snmp
    nikto
    openvpn
    postgresql # for msfdb
    proxychains
    pwndbg
    py2env
    py3env
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
  ];
}
