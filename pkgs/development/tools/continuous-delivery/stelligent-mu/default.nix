{ stdenv, lib, buildGoPackage, fetchFromGitHub, gnumake, git, glide,
  go-bindata, golint, goimports, libseccomp, stringer, python, pkgconfig }:

buildGoPackage rec {
  name = "${pname}-${version}";
  pname = "stelligent-mu";
  version = "0.1.15-develop";
  #rev = "v${version}";
  rev = "90f04ac84fc8a840b5a51e89cff9e8b4f4310e88";

  src = fetchFromGitHub {
    inherit name rev;
    repo = "mu";
    fetchSubmodules = false;

    #sha256 = "12c7ca9fcy1cxr8l82w9dfxfwvdwy86r4fwsvpr80hd5bp2jr08c";
    sha256 = "04p5a3nr8rhc3ikhgpqdvj8hcrg6w6rvn3r9zxir2n9vmp51b95i";

    #owner = "stelligent";
    owner = "nand0p";
  };

  buildInputs = [
    gnumake git glide go-bindata golint goimports libseccomp stringer python pkgconfig
  ];

  outputs = [ "bin" "out" "man" ];

  postInstall = ''
    #wrapProgram $bin/bin/stringer \
    #  --prefix PATH : $}/bin \
    #  --prefix PATH : ${git}/bin

    mkdir -vp $man/share/man/man1
    cp -fv $src/stringer.1 $man/share/man/man1
  '';

  allowGoReference = true;


  configurePhase = ''
    echo $GOPATH
    echo $GOROOT
    mkdir -vp ../go
    cp -r src ../go/
    pwd
    ls -la  ../go/src/github.com
    ls -la  ../go/src/golang.org/x
    go env GOPATH
  '';

  preBuild = ''
    # go generate ./...
    pwd
    go env GOPATH
  '';

  buildPhase = ''
    go env GOPATH
    go build ./...
    pwd
    ls -la ..

    make gen
    #glide --tmp /tmp install
    
    #export GOPATH=$GOPATH:$PWD
    echo $GOPATH
    ls -al 
    make build
  '';

  postBuild = ''
    go env GOPATH
  '';

  checkPhase = ''
    make lint
    make test
  '';

  installPhase = ''
    make install
    mkdir -vp $out/bin
    cp -v mu $out/bin
  '';

  goPackagePath = "github.com/stelligent/mu";

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    homepage = https://github.com/stelligent/mu/;
    description = "μ - A tool for managing your microservices platform";
    maintainers = with maintainers; [ nand0p ];
    platforms = platforms.all;
    license = licenses.asl20;
  };
}
