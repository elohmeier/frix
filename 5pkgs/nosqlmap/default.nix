{ buildPythonPackage, fetchFromGitHub, python3Packages }:

buildPythonPackage {

  pname = "nosqlmap";
  version = "2021-02-13";

  src = fetchFromGitHub {
    owner = "codingo";
    repo = "NoSQLMap";
    rev = "b199389ce936389ed56817647e375612244c1d1a";
    sha256 = "sha256-Y+oB0vVGg8FAN1Ga7PDZD1Her9+HbsQ3uTReQV56Y88=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "CouchDB==1.0" "CouchDB" \
      --replace "httplib2==0.19.0" "httplib2" \
      --replace "ipcalc==1.1.3" "ipcalc" \
      --replace "pbkdf2==1.3" "pbkdf2" \
      --replace "pymongo==2.7.2" "pymongo" \
      --replace "requests==2.20.0" "requests"
  '';

  propagatedBuildInputs = with python3Packages; [ pymongo requests ipcalc ];
}
