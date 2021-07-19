# https://www.youtube.com/watch?v=WiMwVlpD-GU

{ pkgs }:

let
  py3env = pkgs.python3.withPackages (
    pythonPackages: with pythonPackages; [
      authlib
      black
      jupyterlab
      lxml
      keyring
      nbconvert
      pandas
      pdfminer
      pillow
      requests
      selenium
      tabulate
      weasyprint
      beautifulsoup4
      pytest
      mypy
      isort
      termcolor
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

  py2env = py2.withPackages (pythonPackages: with pythonPackages; [ impacket pycrypto requests ]);

  # exploitdb not yet in 21.05, take from master/2021-07-14
  exploitdb_master = with import
    (fetchTarball {
      url = https://github.com/NixOS/nixpkgs/archive/c255408808e7bb2091b3f1954ae63519d6b427ef.tar.gz;
      sha256 = "sha256:0i82mw38c029fgw520wzf5v5akswc2r67rxmkgw8c8lx2di7il80";
    })
    { system = pkgs.system; }; exploitdb;
in
{
  hallo = "welt";

  infosec = with pkgs; [
    cewl
    davtest
    httpserve
    proxychains
    sshuttle
    ghidra-bin
    rlwrap
    hash-identifier
    net-snmp
    metasploit
    postgresql # for msfdb
    wpscan
    john
    gobuster
    burpsuite-pro
    hashcat
    sqlmap
    nbtscanner
    wireshark-qt
    pwndbg
    # TODO: add wordlists from https://github.com/NixOS/nixpkgs/pull/104712
    nikto
    ripgrep-all
    ripgrep
    openvpn
    freerdp
    lftp
    cifs-utils
    dig
    py2env
    py3env
    exploitdb_master
    thc-hydra
    sqsh
  ];



}

