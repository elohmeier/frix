# build a package using `nix build .#pkgname` e.g. `nix build .#burpsuite-pro`

self: super: {
  burpsuite-pro = self.callPackage ./burpsuite-pro { };
  cewl = self.callPackage ./cewl { };
  cf-passthehash =
    (self.writers.writePython2Bin "cf-passthehash"
      {
        libraries = with self.python2Packages; [ requests click ];
        flakeIgnore = [ "E501" "W503" ]; # line length (black)
      } ../4scripts/cf-passthehash.py);
  davtest = self.callPackage ./davtest { };
  hash-identifier = self.callPackage ./hash-identifier { };
  httpserve = (self.writers.writePython3Bin "httpserve"
    {
      flakeIgnore = [ "E501" ]; # line length (black)
    } ../4scripts/httpserve.py);
  kirbi2hashcat =
    (self.writers.writePython2Bin "kirbi2hashcat"
      {
        libraries = [ self.python2Packages.pyasn1 ];
        flakeIgnore = [ "E501" "W503" ]; # line length (black)
      } ../4scripts/kirbi2hashcat.py);
  polenum =
    (self.writers.writePython3Bin "polenum.py"
      {
        libraries = [ self.python3Packages.impacket ];
        flakeIgnore = [ "E501" "W503" ]; # line length (black)
      } ../4scripts/polenum.py);
  snmpcheck = self.callPackage ./snmpcheck { };

  frixPython3 = self.python3.override {
    packageOverrides = self: super: {
      presidio-analyzer = self.callPackage ../5pkgs/presidio/analyzer.nix { };
      presidio-anonymizer = self.callPackage ../5pkgs/presidio/anonymizer.nix { };
      presidio-sample = self.callPackage ../5pkgs/presidio-sample { };
    };
  };
}
