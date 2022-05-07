# from https://github.com/NixOS/nixpkgs/pull/154261

{ lib
, postgresqlSupport ? true
, encryptionSupport ? true
, maubot
, python3
, runCommand
, fetchpatch
}:

let python = python3.override {
  packageOverrides = self: super: {
    # click<8
    click = super.click.overridePythonAttrs (oldAttrs: rec {
      version = "7.1.2";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "06kbzd6sjfkqan3miwj9wqyddfxc2b6hi7p5s4dvqjb3gif2bdfj";
      };
    });
    # mautrix<0.13
    mautrix = super.mautrix.overridePythonAttrs (oldAttrs: rec {
      version = "0.12.5";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "1vm1rsbh2lifa0fsrqxzrq6q0iiww2imrz7v2qs091dawp25q2gp";
      };
      propagatedBuildInputs = [ super.aiohttp super.simplejson super.pyramid ];
    });
    # SQLAlchemy<1.4
    sqlalchemy = super.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
      version = "1.3.24";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "06bmxzssc66cblk1hamskyv5q3xf1nh1py3vi6dka4lkpxy7gfzb";
      };
    });
  };
};
in
with python.pkgs; buildPythonApplication rec {
  pname = "maubot";
  version = "0.2.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ywvrvvq36f1bh4hl9xamj09249px0v4f0v99bgwpr7vpsxrjyhw";
  };

  patches = [
    # add entry point
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/maubot/maubot/pull/146.patch";
      sha256 = "0yn5357z346qzy5v5g124mgiah1xsi9yyfq42zg028c8paiw8s8x";
    })
  ];

  propagatedBuildInputs = [
    # requirements.txt
    mautrix
    aiohttp
    yarl
    sqlalchemy
    alembic
    CommonMark
    ruamel-yaml
    attrs
    bcrypt
    packaging
    click
    colorama
    questionary
    jinja2
  ]
  # optional-requirements.txt
  ++ lib.optionals postgresqlSupport [
    psycopg2
    asyncpg
  ]
  ++ lib.optionals encryptionSupport [
    aiosqlite
    python-olm
    pycryptodome
    unpaddedbase64
  ];

  passthru.tests = {
    simple = runCommand "${pname}-tests" { } ''
      ${maubot}/bin/mbc --help > $out
    '';
  };

  # Setuptools is trying to do python -m maubot test
  dontUseSetuptoolsCheck = true;

  pythonImportsCheck = [
    "maubot"
  ];

  meta = with lib; {
    description = "A plugin-based Matrix bot system written in Python";
    homepage = "https://github.com/maubot/maubot/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ chayleaf ];
  };
}
