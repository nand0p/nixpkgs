{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "incremental";
  version = "16.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hh382gsj5lfl3fsabblk2djngl4n5yy90xakinasyn41rr6pb8l";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/hawkowl/incremental;
    description = "Incremental is a small library that versions your Python projects";
    license = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
