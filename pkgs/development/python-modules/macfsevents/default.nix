{ stdenv, buildPythonPackage, fetchPypi, darwin }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "MacFSEvents";
  version = "0.7";

  buildInputs = [ darwin.apple_sdk.frameworks.Cocoa ];

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vxmpj2iz8lfm03gsb144n1vnglyxs2pf22hpnzka954z3dcvlwm";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/malthe/macfsevents;
    description = "Thread-based interface to file system observation primitives.";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nand0p ];
  };
}
