{ stdenv, fetchurl, buildPythonPackage, openssl, pytest, glibcLocales,
  cryptography, pyasn1, idna }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pyOpenSSL";
  version = "16.2.0";

  src = fetchurl {
    url = "mirror://pypi/p/${pname}/${name}.tar.gz";
    sha256 = "0vji4yrfshs15xpczbhzhasnjrwcarsqg87n98ixnyafnyxs6ybp";
  };

  buildInputs = [ openssl pytest glibcLocales ];

  propagatedBuildInputs = [ cryptography pyasn1 idna ];

  checkPhase = ''
    sed -i 's/test_set_default_verify_paths/noop/' tests/test_ssl.py
    export LANG="en_US.UTF-8";
    py.test;
  '';

  meta = with stdenv.lib; {
    homepage = https://pyopenssl.readthedocs.io;
    description = "Python wrapper module around the OpenSSL library";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nand0p ];
  };
}
