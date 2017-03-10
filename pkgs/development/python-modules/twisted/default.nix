{ stdenv, lib, python, buildPythonPackage, zope_interface, unittest2,
  incremental, constantly, automat, fetchPypi, tox, pytest-incremental,
  pyflakes, subunit, sphinx, pyopenssl, service-identity, idna, pyasn1,
  cryptography, appdirs, pyserial, h2, 

#soappy, priority,

#pyobjc-core, pyobjc-framework-CFNetwork, pyobjc-framework-Cocoa


  #NOTE: cirular deps
  #twistedchecker, pydoctor, twisted_dev_tools 

}:

  buildPythonPackage rec {
    name = "${pname}-${version}";
    version = "17.1.0";
    pname = "Twisted";

    src = fetchPypi {
      inherit pname version;
      compress = "bz2";
      sha256 = "1p245mg15hkxp7hy5cyq2fgvlgjkb4cg0gwkwd148nzy1bbi3wnv";
    };

    buildInputs = [ pytest-incremental tox ];

    propagatedBuildInputs = [ automat constantly incremental zope_interface ];

    # Patch t.p._inotify to point to libc. Without this,
    # twisted.python.runtime.platform.supportsINotify() == False
    patchPhase = lib.optionalString stdenv.isLinux ''
      substituteInPlace twisted/python/_inotify.py --replace \
        "ctypes.util.find_library('c')" "'${stdenv.glibc.out}/lib/libc.so.6'"
    '';

    checkPhase = ''
      tox -e py27-tests
    '';

    # Generate Twisted's plug-in cache.  Twisted users must do it as well.  See
    # http://twistedmatrix.com/documents/current/core/howto/plugin.html#auto3
    # and http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=477103 for
    # details.
    postInstall = "$out/bin/twistd --help > /dev/null";

    doCheck = false;

    meta = with lib; {
      homepage = http://twistedmatrix.com/;
      description = "Twisted, an event-driven networking engine written in Python.";
      license = licenses.mit;
      maintainers = with maintainers; [ nand0p ];
    };
  }
