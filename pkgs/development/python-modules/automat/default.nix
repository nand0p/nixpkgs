{ stdenv, buildPythonPackage, fetchurl, six, attrs }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Automat";
  version = "0.4.0";

  src = fetchurl {
    url = "mirror://pypi/A/${pname}/${name}.tar.gz";
    sha256 = "1xwxs2g9cnibgsm9ppvf540frfqkf36cr0wklmfqf13qwz3ppf94";
  };

  propagatedBuildInputs = [ six attrs ];

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/Automat;
    description = "Self-service finite-state machines for the programmer on the go";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}

