{ stdenv, fetchFromGitHub, autoreconfHook, openssl }:

stdenv.mkDerivation rec {
  baseName = "httperf";
  name = "${baseName}-${version}";
  version = "0.9.1";

  src = fetchFromGitHub {
    repo = "httperf";
    owner = "httperf";
    rev = "3209c7f9b15069d4b79079e03bafba5b444569ff";
    sha256 = "0p48z9bcpdjq3nsarl26f0xbxmqgw42k5qmfy8wv5bcrz6b3na42";
  };

  nativeBuildInputs = [ autoreconfHook ];
  propagatedBuildInputs = [ openssl ];

  configurePhase = ''
    autoreconf -i
  '';

  buildPhase = ''
    mkdir build
    cd build
    ../configure
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv src/httperf $out/bin
  '';

  meta = with stdenv.lib; {
    description = "The httperf HTTP load generator";
    homepage = https://github.com/httperf/httperf;
    maintainers = with maintainers; [ nand0p ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };

}
