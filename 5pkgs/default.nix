self: super: {
  burpsuite-pro = self.callPackage ./burpsuite-pro { };
  davtest = self.callPackage ./davtest { };
  hash-identifier = self.callPackage ./hash-identifier { };
  httpserve = (self.writers.writePython3Bin "httpserve"
    {
      flakeIgnore = [ "E501" ]; # line length (black)
    } ../4scripts/httpserve.py);
  kirbi2hashcat =
    (self.writers.writePython2Bin "kirbi2hashcat"
      {
        libraries = [ python2Packages.pyasn1 ];
        flakeIgnore = [ "E501" "W503" ]; # line length (black)
      } ../4scripts/kirbi2hashcat.py);
}
