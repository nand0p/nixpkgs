{ stdenv, python, buildPythonPackage, fetchPypi, py, virtualenv, pluggy }:

  buildPythonPackage rec {
    name = "${pname}-${version}";
    version = "2.6.0";
    pname = "tox";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0li287y4i49h50cbw86clqdgbhkmyw0afwrpmxmsfi0zjz99hr4i";
    };

    propagatedBuildInputs = [ py virtualenv pluggy ];

    meta = with stdenv.lib; {
      homepage = https://tox.readthedocs.org;
      description = "virtualenv-based automation of test activities.";
      license = licenses.mit;
      maintainers = with maintainers; [ nand0p ];
    };
  }
