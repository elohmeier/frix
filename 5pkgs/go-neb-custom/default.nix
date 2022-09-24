{ lib, buildGoModule, fetchFromGitHub, nixosTests, olm }:

buildGoModule rec {
  pname = "go-neb";
  version = "1.0.2";
  src = fetchFromGitHub {
    owner = "elohmeier";
    repo = "go-neb";
    rev = version;
    sha256 = "sha256-MIfsKv9VAbMRcGfMT+4Zh0ZOhNJoQ0tikd0PgnQedKs=";
  };

  subPackages = [ "." ];

  buildInputs = [ olm ];

  vendorSha256 = "sha256-YpEQUcKBydewAG722gmtTG9JD8NcIJxg9WWu7+YmpW8=";

  doCheck = false;
}
