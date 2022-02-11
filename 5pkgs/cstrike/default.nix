{ stdenv, fetchurl, wine, xvfb-run, writeShellScriptBin }:

let
  game = stdenv.mkDerivation
    {
      pname = "cstrike";
      version = "1.6";
      src = fetchurl {
        url = "https://dl.cs-skini.me/cs/Counter-Strike.exe";
        sha256 = "1qrzx9c0h71fagkxxrd4bcllbwfvbbdph8bfpx5yxw5haqnc8yqd";
      };
      dontUnpack = true;

      buildInputs = [ wine xvfb-run ];

      WINEDLLOVERRIDES = "mscoree,mshtml=";

      buildPhase = ''
        export HOME="$(pwd)"
        xvfb-run wine "$src" /VERYSILENT /DIR="$(pwd)"
      '';

      installPhase = ''
        mkdir -p $out
        cp -r . $out/
      '';
    };
in
# TODO: bubblewrap & mount overlayfs
writeShellScriptBin "cstrike" ''
  CSDIR=$(mktemp -d)
  echo $CSDIR
  cp -r ${game}/* $CSDIR/
  chmod -R 777 $CSDIR
  export WINEPREFIX=$CSDIR/.wine
  export WINEDLLOVERRIDES="mscoree,mshtml="
  cd $CSDIR
  ${wine}/bin/wine start CS16Launcher.exe -steam -noforcemparms -noforcemaccel -game cstrike
''
