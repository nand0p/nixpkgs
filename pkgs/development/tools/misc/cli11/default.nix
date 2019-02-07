{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "cli11-${version}";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "CLIUtils";
    repo = "CLI11";
    #rev = "49ac989a9527ee9bb496de9ded7b4872c2e0e5ca";
    rev = "v${version}";
    sha256 = "0wddck970pczk7c201i2g6s85mkv4f2f4zxy6mndh3pfz41wcs2d";
    #fetchSubmodules = true;
  };

  buildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DCLI11_TESTING=OFF"
    "-DINTERFACE_INCLUDE_DIRECTORIES=$out"
  ];

  buildPhase = ''
    #mkdir -v build
    #pushd build
    cmake . $cmakeFlags
  '';

  installPhase = ''
    mkdir -pv $out
    cp -rv * $out
    cp -v CMakeFiles/Export/lib/cmake/CLI11/CLI11Config.cmake $out/cli11-config.cmake
  '';

}
