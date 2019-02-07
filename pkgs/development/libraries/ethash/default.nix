{ lib, pkgs, stdenv, fetchFromGitHub, cmake, boost, cryptopp, opencl-headers, opencl-info,
  openmpi, ocl-icd, mesa, gbenchmark, gtest }:

stdenv.mkDerivation rec {
  name = "${pkgname}-${version}";
  pkgname = "ethash";
  version = "0.4.2";

  src =
    fetchFromGitHub {
      owner = "chfast";
      repo = "ethash";
      rev = "v${version}";
      sha256 = "0qiixvxbpl2gz7jh1qs8lmyk7wzv6ffnl7kckqgrpgm547nnn8zy";
    };

  buildInputs = [
    cmake
    boost
    cryptopp
    opencl-headers
    opencl-info
    openmpi
    ocl-icd
    mesa
    gbenchmark
    gtest
  ];

  # NOTE: disabling tests due to gtest issue
  cmakeFlags = [
    "-DHUNTER_ENABLED=OFF"
    "-DETHASH_BUILD_TESTS=OFF"
  ];

  buildPhase = ''
    cmake . $cmakeFlags
    cmake --build .
  '';

  installPhase = ''
    mkdir -pv $out
    cp -vr * $out
    cp -fv $(find . -name ethashTargets.cmake) $out/lib/ethash
  '';

  meta = with stdenv.lib; {
    description = "PoW algorithm for Ethereum 1.0 based on Dagger-Hashimot";
    homepage = https://github.com/ethereum/ethash;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ nand0p ];
    license = licenses.gpl2;
  };
}
