{ stdenv, python, buildPythonPackage, fetchPypi, m2r, setuptools_scm, attrs, six }:

  buildPythonPackage rec {
    name = "${pname}-${version}";
    version = "0.5.0";
    pname = "Automat";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1hnpknkqnc2m900kkzrzx9l6g5dy5dassrdj9pn34x1pcdkyr2a8";
    };

    buildInputs = [ m2r setuptools_scm ];

    propagatedBuildInputs = [ attrs six ];

    meta = with stdenv.lib; {
      homepage = https://github.com/glyph/Automat;
      description = "Self-service finite-state machines for the programmer on the go.";
      license = licenses.mit;
      maintainers = with maintainers; [ nand0p ];
    };
  }
