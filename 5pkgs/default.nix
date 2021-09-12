# build a package using `nix build .#pkgname` e.g. `nix build .#burpsuite-pro`

self: pkgs_master: super: {
  burpsuite-pro = self.callPackage ./burpsuite-pro { };
  cewl = self.callPackage ./cewl { };
  cf-passthehash =
    (self.writers.writePython2Bin "cf-passthehash"
      {
        libraries = with self.python2Packages; [ requests click ];
        flakeIgnore = [ "E265" "E501" "W503" ];
      } ../4scripts/cf-passthehash.py);
  davtest = self.callPackage ./davtest { };
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
  kirbi2hashcat =
    (self.writers.writePython2Bin "kirbi2hashcat"
      {
        libraries = [ self.python2Packages.pyasn1 ];
        flakeIgnore = [ "E265" "E501" "W503" ];
      } ../4scripts/kirbi2hashcat.py);
  ligolo-ng = self.callPackage ./ligolo-ng { };
  polenum =
    (self.writers.writePython3Bin "polenum.py"
      {
        libraries = [ self.python3Packages.impacket ];
        flakeIgnore = [ "E265" "E501" "W503" ];
      } ../4scripts/polenum.py);
  snmpcheck = self.callPackage ./snmpcheck { };
  syncthing-device-id = self.callPackage ./syncthing-device-id { };
  win10fonts = self.callPackage ./win10fonts { };

  frixPython3 = self.python3.override {
    packageOverrides = self: super: {
      nosqlmap = self.callPackage ../5pkgs/nosqlmap { };
      presidio-analyzer = self.callPackage ../5pkgs/presidio/analyzer.nix { };
      presidio-anonymizer = self.callPackage ../5pkgs/presidio/anonymizer.nix { };
      presidio-sample = self.callPackage ../5pkgs/presidio-sample { };
    };
  };

  frixPython2 = self.python2.override {
    packageOverrides = pyself: pysuper: rec {
      certifi = pysuper.buildPythonPackage rec {
        pname = "certifi";
        version = "2020.04.05.1"; # last version with python2 support
        src = self.fetchFromGitHub {
          owner = pname;
          repo = "python-certifi";
          rev = version;
          sha256 = "sha256-scdb86Bg5tTUDwm5OZ8HXar7VCNlbPMtt4ZzGu/2O4w=";
        };
      };
    };
  };

  frixPython3Env = pkgs_master.python3.withPackages (
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


  frixPython2Env = self.frixPython2.withPackages (pythonPackages: with pythonPackages; [
    impacket
    pycrypto
    requests
  ]);

  # pull in recent versions from >21.05
  exploitdb = pkgs_master.exploitdb;
  fluent-bit = pkgs_master.fluent-bit;
  foot = pkgs_master.foot;

  # fluent-bit config generation example
  fluent-config = self.writeText "fluent.conf" (self.lib.generators.toINI
    {
      mkKeyValue = k: v: self.lib.generators.mkKeyValueDefault { } "=" "  ${k}" v;
    }
    {
      section_a = {
        foo = "bar";
      };

      section_b = {
        host = "127.0.0.1";
        port = 12345;
      };
    });
}
