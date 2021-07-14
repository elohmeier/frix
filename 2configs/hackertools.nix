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
in
{
  hallo = "welt";

  infosec = with pkgs; [
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
    kirbi2hashcat
  ];



}

