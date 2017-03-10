{ stdenv, python, buildPythonPackage, fetchPypi, twisted, epydoc }:

  buildPythonPackage rec {
    name = "${pname}-${version}";
    version = "16.3.0";
    pname = "pydoctor";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0glm0519b373b24ba1mp04c1qinqp3cgfzl3wp1gpgagbgch1x71";
    };

    buildInputs = [ twisted epydoc ];

    meta = with stdenv.lib; {
      homepage = http://github.com/twisted/pydoctor;
      description = "API doc generator.";
      license = licenses.mit;
      maintainers = with maintainers; [ nand0p ];
    };
  }
