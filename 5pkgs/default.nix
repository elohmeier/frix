self: super: {
  burpsuite-pro = self.callPackage ./burpsuite-pro { };
  hash-identifier = self.callPackage ./hash-identifier { };
  httpserve = (self.writers.writePython3Bin "httpserve"
    {
      flakeIgnore = [ "E501" ]; # line length (black)
    } ../4scripts/httpserve.py);
}
