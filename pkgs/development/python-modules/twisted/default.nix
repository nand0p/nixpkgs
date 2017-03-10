{ stdenv, lib, python, buildPythonPackage, zope_interface, unittest2,
  incremental, constantly, fetchPypi }:

  buildPythonPackage rec {
    name = "${pname}-${version}";
    version = "17.1.0";
    pname = "Twisted";

    src = fetchPypi {
      inherit pname version;
      compress = "bz2";
      sha256 = "1p245mg15hkxp7hy5cyq2fgvlgjkb4cg0gwkwd148nzy1bbi3wnv";
    };

    buildInputs = [ constantly incremental unittest2 ];

    propagatedBuildInputs = [ zope_interface ];

    # Patch t.p._inotify to point to libc. Without this,
    # twisted.python.runtime.platform.supportsINotify() == False
    #patchPhase = optionalString stdenv.isLinux ''
    #  substituteInPlace twisted/python/_inotify.py --replace \
    #    "ctypes.util.find_library('c')" "'${stdenv.glibc.out}/lib/libc.so.6'"
    #'';

    checkPhase = ''
      tox -e py27-tests
    '';

    # Generate Twisted's plug-in cache.  Twisted users must do it as well.  See
    # http://twistedmatrix.com/documents/current/core/howto/plugin.html#auto3
    # and http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=477103 for
    # details.
    postInstall = "$out/bin/twistd --help > /dev/null";

    meta = with lib; {
      homepage = http://twistedmatrix.com/;
      description = "Twisted, an event-driven networking engine written in Python.";
      license = licenses.mit;
      maintainers = with maintainers; [ nand0p ];
    };
  }
