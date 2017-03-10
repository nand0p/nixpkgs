{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "epydoc";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wj8dqbybhc97ml29wyyzn6r7sfbrkbmvqrr5g26xc7safw6j568";
  };

  meta = with stdenv.lib; {
    homepage = http://epydoc.sourceforge.net;
    description = "Edward Loper's API Documentation Generation Tool";
    license = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
