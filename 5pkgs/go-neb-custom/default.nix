{ lib, buildGoModule, fetchFromGitHub, nixosTests, olm }:

buildGoModule rec {
  pname = "go-neb";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "elohmeier";
    repo = "go-neb";
    rev = version;
    sha256 = "sha256-T1aGSzrDmWy+1th48cjZq8m/lZP00U1UA+O8xuXPLBk=";
  };

  subPackages = [ "." ];

  buildInputs = [ olm ];

  vendorSha256 = "sha256-YpEQUcKBydewAG722gmtTG9JD8NcIJxg9WWu7+YmpW8=";

  doCheck = false;
}
