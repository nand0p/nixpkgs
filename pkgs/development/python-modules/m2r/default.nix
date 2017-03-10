{ stdenv, lib, python, buildPythonPackage, fetchPypi, mistune, docutils }:

  buildPythonPackage rec {
    name = "${pname}-${version}";
    version = "0.1.5";
    pname = "m2r";

    src = fetchPypi {
      inherit pname version;
      sha256 = "08rjn3x1qag60wawjnq95wmgijrn33apr4fhj01s2p6hmrqgfj1l";
    };

    propagatedBuildInputs = [ mistune docutils ];

    meta = with lib; {
      homepage = https://github.com/miyakogi/m2r;
      description = "Markdown to reStructuredText converter.";
      license = licenses.mit;
      maintainers = with maintainers; [ nand0p ];
    };
  }
