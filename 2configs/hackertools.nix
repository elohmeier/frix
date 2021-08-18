# https://www.youtube.com/watch?v=WiMwVlpD-GU

{ pkgs }:

let
  # exploitdb & python-lsp-server not yet in 21.05, take from master/2021-07-14
  nixpkgs_master = import
    (fetchTarball {
      url = https://github.com/NixOS/nixpkgs/archive/c255408808e7bb2091b3f1954ae63519d6b427ef.tar.gz;
      sha256 = "sha256:0i82mw38c029fgw520wzf5v5akswc2r67rxmkgw8c8lx2di7il80";
    })
    { system = pkgs.system; };

  py3env = nixpkgs_master.python3.withPackages (
    pythonPackages: with pythonPackages; [
      authlib
      beautifulsoup4
      black
      isort
      jupyterlab
      keyring
      lxml
      mypy
      mysql-connector
      nbconvert
      pandas
      pdfminer
      pillow
      pytest
      requests
      selenium
      sshtunnel
      tabulate
      termcolor
      weasyprint
      pylint
      python-lsp-server
      google-auth
      google-auth-oauthlib
      google-api-python-client
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
in
rec {
  # TODO: add wordlists from https://github.com/NixOS/nixpkgs/pull/104712
  infosec_no_pyenv = with pkgs; [
    burpsuite-pro
    cewl
    cifs-utils
    davtest
    dig
    enum4linux
    nixpkgs_master.exploitdb
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
    py2env
    py3env
  ];
}
