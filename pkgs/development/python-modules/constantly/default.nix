{ stdenv, lib, python, buildPythonPackage, fetchPypi, tox }:

  buildPythonPackage rec {
    name = "${pname}-${version}";
    version = "15.1.0";
    pname = "constantly";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0dgwdla5kfpqz83hfril716inm41hgn9skxskvi77605jbmp4qsq";
    };

    buildInputs = [ tox ];

    checkPhase = ''
      tox
    '';

    meta = with lib; {
      homepage = https://github.com/twisted/constantly;
      description = "Symbolic constants in Python.";
      license = licenses.mit;
      maintainers = with maintainers; [ nand0p ];
    };
  }
