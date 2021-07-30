{ buildPythonPackage
, presidio-analyzer
, presidio-anonymizer
, flask
, spacy_models
, whitenoise
, python
}:

buildPythonPackage {
  name = "presidio-sample";
  src = ./.;

  postPatch = ''
    substituteInPlace sample/app.py \
      --replace "root=\"static/\"" "root=\"$out/${python.sitePackages}/sample/static\""
  '';

  propagatedBuildInputs = [
    presidio-analyzer
    presidio-anonymizer
    flask
    #spacy_models.en_core_web_lg
    spacy_models.de_core_news_md
    whitenoise
  ];
}
