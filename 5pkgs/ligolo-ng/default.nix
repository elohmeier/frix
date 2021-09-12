{ buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ligolo-ng";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "tnpitsecurity";
    repo = "ligolo-ng";
    rev = "v${version}";
    sha256 = "sha256-Ipfp+Ke4iSJmvUtfNUt/XSPTSDSdeMs+Ss8acZHUYrE=";
  };

  vendorSha256 = "sha256-axRCThmFavR+GTRWSgdAr2mbrp07hsFea0rKLQNIhgU=";

  doCheck = false;
}
