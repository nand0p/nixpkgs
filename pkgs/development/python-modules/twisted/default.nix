{ stdenv, buildPythonPackage, fetchurl, zope_interface, automat, coreutils, gzip,
  incremental, constantly, tox, libffi, openssl, glibcLocales, bash, gnused }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Twisted";
  version = "17.1.0rc1";

  src = fetchurl {
    url = "mirror://pypi/T/${pname}/${name}.tar.bz2";
    sha256 = "0hprqm6y055zs1j86lr41b4cj9vv9nhiz8bqk2byha8672252ljr";
  };

  nativeBuildInputs = [ coreutils gzip ];

  buildInputs = [ tox libffi openssl glibcLocales ];

  propagatedBuildInputs = [ zope_interface automat incremental constantly ];

  patchPhase = stdenv.lib.optionalString stdenv.isLinux ''
    # Patch t.p._inotify to point to libc. Without this,
    # twisted.python.runtime.platform.supportsINotify() == False
    substituteInPlace src/twisted/internet/inotify.py --replace \
      "ctypes.util.find_library('c')" "'${stdenv.glibc.out}/lib/libc.so.6'"

    ${gnused}/bin/sed -i "s|/usr/bin|/run/current-system/sw/bin|" src/twisted/test/test_process.py
    ${gnused}/bin/sed -i "|test_log.py|d" twisted/trial/test/test_script.py
  '';

  checkPhase = ''
    export LANG="en_US.UTF-8";
    ${tox}/bin/tox -e py27-tests
  '';

  # Generate Twisted's plug-in cache.  Twisted users must do it as well.  See
  # http://twistedmatrix.com/documents/current/core/howto/plugin.html#auto3
  # and http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=477103 for details.
  postInstall = ''
    $out/bin/twistd --help > /dev/null
  '';

  meta = with stdenv.lib; {
    homepage = http://twistedmatrix.com/;
    description = "Twisted, an event-driven networking engine written in Python";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}

