{ stdenv, lib, python, buildPythonPackage, fetchPypi, m2r,
  setuptools_scm, attrs, six, graphviz, twisted }:

  buildPythonPackage rec {
    name = "${pname}-${version}";
    version = "0.5.0";
    pname = "Automat";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1hnpknkqnc2m900kkzrzx9l6g5dy5dassrdj9pn34x1pcdkyr2a8";
    };

    buildInputs = [ m2r setuptools_scm ];

    propagatedBuildInputs = [ attrs six graphviz twisted ];

    meta = with lib; {
      homepage = https://github.com/twisted/constantly;
      description = "Symbolic constants in Python.";
      license = licenses.mit;
      maintainers = with maintainers; [ nand0p ];
    };
  }
