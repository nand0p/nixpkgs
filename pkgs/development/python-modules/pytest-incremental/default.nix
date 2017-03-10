{ stdenv, python, buildPythonPackage, fetchPypi, six, pytest,
  doit, configparser, macfsevents }:

  buildPythonPackage rec {
    name = "${pname}-${version}";
    version = "0.4.2";
    pname = "pytest-incremental";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0wimldwy39k681cdf33v6m2mwh38jzmdrxc0plkmp7bv13n0jp42";
    };

    buildInputs = [ pytest doit configparser macfsevents ];

    propagatedBuildInputs = [ six ];

    meta = with stdenv.lib; {
      homepage = http://pytest-incremental.readthedocs.org;
      description = "An incremental test runner (pytest plug-in).";
      license = licenses.mit;
      maintainers = with maintainers; [ nand0p ];
    };
  }
