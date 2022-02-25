{ fetchFromGitHub
, lib
, stdenvNoCC
}:

stdenvNoCC.mkDerivation rec {
  pname = "SecLists";
  version = "unstable-2021-08-28";

  src = fetchFromGitHub {
    owner = "danielmiessler";
    repo = pname;
    rev = "cb81804316c634728bbddb857ce7dfa5016e01b1";
    sha256 = "sha256-QBlZlS8JJI6pIdIaD1I+7gMuPPfEybxybj2HrnQM7co=";
  };

  buildPhase = ''
    tar xzvf ./Passwords/Leaked-Databases/rockyou.txt.tar.gz -C ./Passwords/Leaked-Databases/
    rm ./Passwords/Leaked-Databases/rockyou.txt.tar.gz
  '';

  installPhase = ''
    mkdir -p $out/share/wordlists/SecLists
    cp -R Discovery Fuzzing IOCs Miscellaneous Passwords Pattern-Matching Payloads Usernames Web-Shells \
      $out/share/wordlists/SecLists
    find $out/share/wordlists/SecLists -name "*.md" -delete
  '';

  meta = with lib; {
    homepage = "https://github.com/danielmiessler/SecLists";
    license = licenses.mit;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
