# build a package using `nix build .#pkgname` e.g. `nix build .#burpsuite-pro`

self: pkgs_master: super: {
  burpsuite-pro = self.callPackage ./burpsuite-pro { };

  cewl = self.callPackage ./cewl { };
  cstrike = self.callPackage ./cstrike { };
  cf-passthehash =
    (self.writers.writePython2Bin "cf-passthehash"
      {
        libraries = with self.python2Packages; [ requests click ];
        flakeIgnore = [ "E265" "E501" "W503" ];
      } ../4scripts/cf-passthehash.py);
  davtest = self.callPackage ./davtest { };
  faraday-cli = super.faraday-cli.overrideAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ [
      super.python3.pkgs.packaging
    ];
  });

  gomumblesoundboard = self.callPackage ./gomumblesoundboard { };
  hash-identifier = self.callPackage ./hash-identifier { };
  hashPassword = self.callPackage ./hashPassword { };
  httpserve = (self.writers.writePython3Bin "httpserve"
    {
      flakeIgnore = [ "E265" "E501" ];
    } ../4scripts/httpserve.py);
  kali-vm-image = self.callPackage ./kali-vm-image { };
  ligolo-ng = self.callPackage ./ligolo-ng { };
  maubot = self.callPackage ./maubot { };
  nasm-shell =
    (self.writers.writeDashBin "nasm-shell"
      ''export PATH=$PATH:${self.nasm}/bin
        ${self.python3}/bin/python3 ${../4scripts/nasm-shell.py}'');
  nippel = self.fetchzip {
    url = "https://www.nerdworks.de/dl/nippel.tgz";
    sha256 = "sha256-StNVBmcfzNIIdCNqAH4bcOE4O7VtGRQaE65ARXZ5AB4=";
  };
  mumble-nippelboard = self.writeShellScriptBin "mumble-nippelboard" ''
    USERNAME="''${1?provide username}"
    PASSWORD="''${2?provide password}"
    cd ${self.gomumblesoundboard}
    ${self.gomumblesoundboard}/bin/gomumblesoundboard -server voice.fraam.de:64738 -username "$USERNAME" -password "$PASSWORD" -channel Hacken ${self.nippel}/*.mp3
  '';
  phpmyadmin = self.callPackage ./phpmyadmin { };
  polenum =
    (self.writers.writePython3Bin "polenum.py"
      {
        libraries = [ self.python3Packages.impacket ];
        flakeIgnore = [ "E265" "E501" "W503" ];
      } ../4scripts/polenum.py);
  run-kali-vm = self.callPackage ./run-kali-vm { };
  run-win-vm = self.callPackage ./run-win-vm { };
  snmpcheck = self.callPackage ./snmpcheck { };
  win10fonts = self.callPackage ./win10fonts { };
  windows-vm-image = self.callPackage ./windows-vm-image { };
  wordlists-nmap = self.callPackage ./wordlists/nmap { };
  wordlists-seclists = self.callPackage ./wordlists/seclists { };

  vscode-with-extensions = pkgs_master.vscode-with-extensions;
  vscode = pkgs_master.vscode;
  vscode-extensions = pkgs_master.vscode-extensions;

  frixPython3 = self.python3.override {
    packageOverrides = self: super: {
      nosqlmap = self.callPackage ../5pkgs/nosqlmap { };
      presidio-analyzer = self.callPackage ../5pkgs/presidio/analyzer.nix { };
      presidio-anonymizer = self.callPackage ../5pkgs/presidio/anonymizer.nix { };
      presidio-sample = self.callPackage ../5pkgs/presidio-sample { };
    };
  };

  frixPython3Env = self.python3.withPackages (
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

  frixPython2Env = self.python2.withPackages (pythonPackages: with pythonPackages; [
    impacket
    pycrypto
    requests
  ]);

  # https://www.youtube.com/watch?v=WiMwVlpD-GU
  hackertools = with self; [
    amass
    burpsuite-pro
    cewl
    cifs-utils
    crowbar
    davtest
    dig
    enum4linux
    exploitdb
    faraday-cli
    freerdp
    gobuster
    ffuf
    hash-identifier
    hashcat
    httpserve
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
    nuclei
    openvpn
    polenum
    postgresql # for msfdb
    proxychains
    pwndbg
    ripgrep
    ripgrep-all
    rlwrap
    rustscan
    samba
    socat
    snmpcheck
    sqlmap
    sqsh
    ssh-audit
    sshuttle
    sslscan
    thc-hydra
    wireshark-qt
    wordlists-nmap
    wordlists-seclists
    wpscan
    zig
  ] ++ self.lib.optionals (self.stdenv.hostPlatform.system != "aarch64-linux") [
    ghidra-bin
  ];

  logseq = pkgs_master.logseq;

  go-neb = self.callPackage ./go-neb-custom { };
  botamusique = pkgs_master.botamusique;
  tailscale = pkgs_master.tailscale;
}
