{ fetchurl, lib, pkgs, stdenv, fetchFromGitHub, opencl-headers, cmake, jsoncpp, boost,
  cudatoolkit, mesa, ethash, opencl-info, ocl-icd, openssl, git, dbus, cli11, pkg-config }:

stdenv.mkDerivation rec {
  name = "${pkgname}-${version}";
  pkgname = "ethminer";
  version = "0.17.0";

  src =
    fetchFromGitHub {
      owner = "ethereum-mining";
      repo = "ethminer";
      rev = "e6868d38b38ba3e6639c11bba3ece99a1b44b6b7";
      sha256 = "08yhqc6ndmm576rrgv57f6vg5xkgxlddbhpp97q7dlq9qf3r8kcj";
      fetchSubmodules = true;
    };

  #nativeBuildInputs = [ makeWrapper ];
  #enableParallelBuilding = true;

  cmakeFlags = [ "-DHUNTER_ENABLED=OFF"
                 "-DETHASHCUDA=ON"
                 "-DCMAKE_INSTALL_PREFIX=./install"
                 "-DAPICORE=ON"
                 "-DETHDBUS=ON"
                 "-DCMAKE_BUILD_TYPE=Release"
                 "-Djsoncpp_DIR=${jsoncpp}/lib/cmake/jsoncpp"
                 "-Dethash_DIR=${ethash}/lib"
                 "-DCLI11_DIR=${cli11}"
  ];

  configurePhase = ''
    mkdir -p build/install
    pushd build
    cmake .. $cmakeFlags
  '';

  buildInputs = [
    git
    cmake
    boost
    opencl-headers
    mesa
    cudatoolkit
    ethash
    opencl-info
    ocl-icd
    openssl
    dbus
    cli11
    pkg-config
  ];


  #installPhase = ''
  #  mkdir -vp $out/bin
  #  mv -v ethminer $out/bin
  #  patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2 $out/bin/ethminer
  #  patchelf --set-rpath $(pwd):${stdenv.cc.libc}/lib $out/bin/ethminer
  #  wrapProgram $out/bin/ethminer --set LD_LIBRARY_PATH "/run/opengl-driver/lib:/run/opengl-driver-32/lib"
  #'';

  runPath = with stdenv.lib; makeLibraryPath ([ stdenv.cc.cc ] ++ buildInputs);

  installPhase = ''
    make install
    mkdir -p $out
    for f in install/lib/*.so* $(find install/bin -executable -type f); do
      patchelf --set-rpath $runPath:$out/lib $f
    done
    cp -r install/* $out
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
