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

  frix-copy-secrets = (self.writers.writePython3Bin "frix-copy-secrets"
    {
      flakeIgnore = [ "E265" "E501" ];
      libraries = [ self.python3Packages.python-gnupg ];
    } ../4scripts/frix-copy-secrets.py);
  frix-gen-secrets = self.callPackage ./frix-gen-secrets { };
  hash-identifier = self.callPackage ./hash-identifier { };
  hashPassword = self.callPackage ./hashPassword { };
  httpserve = (self.writers.writePython3Bin "httpserve"
    {
      flakeIgnore = [ "E265" "E501" ];
    } ../4scripts/httpserve.py);
  kali-vm-image = self.callPackage ./kali-vm-image { };
  kirbi2hashcat =
    (self.writers.writePython2Bin "kirbi2hashcat"
      {
        libraries = [ self.python2Packages.pyasn1 ];
        flakeIgnore = [ "E265" "E501" "W503" ];
      } ../4scripts/kirbi2hashcat.py);
  ligolo-ng = self.callPackage ./ligolo-ng { };
  nasm-shell =
    (self.writers.writeDashBin "nasm-shell"
      ''export PATH=$PATH:${self.nasm}/bin
        ${self.python3}/bin/python3 ${../4scripts/nasm-shell.py}'');
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
  syncthing-device-id = self.callPackage ./syncthing-device-id { };
  win10fonts = self.callPackage ./win10fonts { };
  windows-vm-image = self.callPackage ./windows-vm-image { };
  wordlists-nmap = self.callPackage ./wordlists/nmap { };
  wordlists-seclists = self.callPackage ./wordlists/seclists { };

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
    creddump
    crowbar
    davtest
    dig
    enum4linux
    exploitdb
    faraday-cli
    freerdp
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
    sshuttle
    thc-hydra
    wireshark-qt
    wordlists-nmap
    wordlists-seclists
    wpscan
    zig
  ] ++ self.lib.optionals (self.stdenv.hostPlatform.system != "aarch64-linux") [
    ghidra-bin
  ];
}
