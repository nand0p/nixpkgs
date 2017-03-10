{ stdenv, python, buildPythonPackage, fetchPypi, tox }:

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

    # NOTE: no tests written yet
    doCheck = false;

    meta = with stdenv.lib; {
      homepage = https://github.com/twisted/constantly;
      description = "Symbolic constants in Python.";
      license = licenses.mit;
      maintainers = with maintainers; [ nand0p ];
    };
  }
