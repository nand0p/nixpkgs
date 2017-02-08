{ stdenv, buildPythonPackage, fetchurl, tox }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "constantly";
  version = "15.1.0";

  src = fetchurl {
    url = "mirror://pypi/c/${pname}/${name}.tar.gz";
    sha256 = "0dgwdla5kfpqz83hfril716inm41hgn9skxskvi77605jbmp4qsq";
  };

  buildInputs = [ tox ];

  checkPhase = ''
    tox
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/twisted/constantly;
    description = "Symbolic constants in Python";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}

