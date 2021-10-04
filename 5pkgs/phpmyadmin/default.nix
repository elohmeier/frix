{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "phpmyadmin";
  version = "5.1.1";

  src = fetchurl {
    url = "https://files.phpmyadmin.net/phpMyAdmin/${version}/phpMyAdmin-${version}-all-languages.zip";
    sha256 = "sha256-eKXZNiH5/fwiGlMHBQJdx5wavHpNapQKnQqaNxnQVUw=";
  };

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out
    cp -r . $out/
  '';
}
