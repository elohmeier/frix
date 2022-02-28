{ fetchFromGitHub
, lib
, stdenvNoCC
}:

stdenvNoCC.mkDerivation rec {
  pname = "SecLists";
  version = "unstable-2022-02-02";

  src = fetchFromGitHub {
    owner = "danielmiessler";
    repo = pname;
    rev = "168584fdc61b44080342291611238585648f08a8";
    sha256 = "sha256-zorSUK89LClclqwLpdg+4SJaB/ioXy1PiW6UBWZwNm4=";
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
  };
}
