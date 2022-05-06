{ lib, buildGoModule, fetchFromGitHub, nixosTests, olm }:

buildGoModule rec {
  pname = "go-neb";
  version = "1.0.1";
  src = fetchFromGitHub {
    owner = "elohmeier";
    repo = "go-neb";
    rev = version;
    sha256 = "sha256-9aDG/0GzIQX7gN7w92ol7WjFqye/Yu33lB663Cx0lb8=";
  };

  subPackages = [ "." ];

  buildInputs = [ olm ];

  vendorSha256 = "sha256-YpEQUcKBydewAG722gmtTG9JD8NcIJxg9WWu7+YmpW8=";

  doCheck = false;
}
