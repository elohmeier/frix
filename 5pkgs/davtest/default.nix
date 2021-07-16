{ stdenv, fetchFromGitHub, perl }:

let
  perlEnv = perl.withPackages (p: [ p.HTTPDAV ]);
in
stdenv.mkDerivation rec {
  pname = "davtest";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "cldrn";
    repo = "davtest";
    rev = "76ee74ccca46209caec96d2d310ae050f164b4f5";
    sha256 = "sha256-FgB4dXtPwZP8NgRJFlpl2BPjPW4yZLDskJVaWQlbEnY=";
  };

  patchPhase = ''
    substituteInPlace davtest.pl \
      --replace "#!/usr/bin/perl" \
                "#!${perlEnv}/bin/perl" \
      --replace "my @files = dirlist(\"tests/\", \".*\.txt\");" \
                "my @files = dirlist(\"$out/share/davtest/tests/\", \".*\.txt\");" \
      --replace "open(TESTFILE, \"<tests/\$file\")" \
                "open(TESTFILE, \"<$out/share/davtest/tests/\$file\")"
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/davtest/{backdoors,tests}
    cp davtest.pl $out/bin/davtest
    cp backdoors/* $out/share/davtest/backdoors/
    cp tests/* $out/share/davtest/tests/
  '';
}
