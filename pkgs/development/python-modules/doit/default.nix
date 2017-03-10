{ stdenv, buildPythonPackage, fetchPypi, configparser, cloudpickle,
  six, macfsevents }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "doit";
  version = "0.28.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gsi8xqfdlc7f530z3slrll74hc25zcnmnyb98s2hrsnwayzx8hj";
  };

  buildInputs = [ six configparser cloudpickle ] ++
    stdenv.lib.optionals stdenv.isDarwin [ macfsevents ];

  meta = with stdenv.lib; {
    homepage = http://pydoit.org;
    description = "doit is a task management & automation tool";
    license = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
