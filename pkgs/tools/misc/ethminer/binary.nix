{ stdenv, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "${pkgname}-${version}";
  pkgname = "ethminer";
  version = "0.17.0";

  src =
    fetchurl {
      url = "https://github.com/ethereum-mining/${pkgname}/releases/download/v${version}/${name}-linux-x86_64.tar.gz";
      sha256 = "1ivjqvbh79dggpab7dvxip79jmjqh0krcmh68k6f2mvpyg1x3f1c";
    };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -vp $out/bin
    mv -v ethminer $out/bin
    patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2 $out/bin/ethminer
    patchelf --set-rpath $(pwd):${stdenv.cc.libc}/lib $out/bin/ethminer
    wrapProgram $out/bin/ethminer --set LD_LIBRARY_PATH "/run/opengl-driver/lib:/run/opengl-driver-32/lib"
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Ethereum miner with OpenCL, CUDA and stratum support";
    homepage = https://github.com/ethereum-mining/ethminer;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ nand0p ];
    license = licenses.gpl2;
  };
}
