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
        libraries = [ self.python2Packages.pyasn1 ];
        flakeIgnore = [ "E501" "W503" ]; # line length (black)
      } ../4scripts/kirbi2hashcat.py);
  cf-passthehash =
      (self.writers.writePython2Bin "cf-passthehash"
           {
             libraries = with self.python2Packages; [ requests click ];
             flakeIgnore = [ "E501" "W503" ]; # line length (black)
           } ../4scripts/cf-passthehash.py);
}
