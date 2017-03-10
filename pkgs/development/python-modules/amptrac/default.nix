{ stdenv, python, buildPythonPackage, fetchPypi, treq }:

  buildPythonPackage rec {
    name = "${pname}-${version}";
    version = "0.1";
    pname = "amptrac";

    buildInputs = [ treq ];

    src = fetchPypi {
      inherit pname version;
      sha256 = "1lfbmanignvhvdm08k538nh15kzjwyhb5sbmmzyl1cm9awhzdcfn";
    };

    meta = with stdenv.lib; {
      homepage = https://github.com/twisted-infra/amptrac;
      description = "Client for twisted's amp interface to trac.";
      license = licenses.mit;
      maintainers = with maintainers; [ nand0p ];
    };
  }
