{ lib, writers, fetchFromGitHub, perlPackages }:

# v1.2
let src = fetchFromGitHub {
  owner = "cldrn";
  repo = "davtest";
  rev = "76ee74ccca46209caec96d2d310ae050f164b4f5";
  sha256 = "sha256-FgB4dXtPwZP8NgRJFlpl2BPjPW4yZLDskJVaWQlbEnY=";
};
in
writers.writePerlBin "davtest" { libraries = [ perlPackages.HTTPDAV ]; } (lib.readFile "${src}/davtest.pl")
