self: super: {
  burpsuite-pro = self.callPackage ./burpsuite-pro { };
  hash-identifier = self.callPackage ./hash-identifier { };
}
