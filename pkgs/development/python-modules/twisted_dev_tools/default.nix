{ stdenv, python, buildPythonPackage, fetchPypi, treq, twisted, amptrac }:

  buildPythonPackage rec {
    name = "${pname}-${version}";
    version = "0.0.2";
    pname = "twisted-dev-tools";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0pql578prpnd0qaizbrs57132z5h6jx2k03b8ixj72rgdl0xmk9d";
    };

    buildInputs = [ treq twisted amptrac ];

    meta = with stdenv.lib; {
      homepage = https://github.com/twisted/twisted-dev-tools;
      description = "Tools for twisted development.";
      license = licenses.mit;
      maintainers = with maintainers; [ nand0p ];
    };
  }
