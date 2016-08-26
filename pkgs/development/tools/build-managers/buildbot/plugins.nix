{ stdenv,
  fetchurl,
  pythonPackages
}:

let
  buildbot-pkg = pythonPackages.buildPythonPackage rec {
    name = "buildbot-pkg-${version}";
    version = "0.9.0rc2";

    src = fetchurl {
      url = "https://pypi.python.org/packages/95/47/1fef931d410cc24127564c2e193e7c1c184f5c5f481930f77c6d6840cfab/${name}.tar.gz";
      sha256 = "01wc9bmqq1rfayqnjm7rkjhbcj7h6ah4vv10s6hglnq9s4axvxp6";
    };

    propagatedBuildInputs = with pythonPackages; [ setuptools ];

    # doesn't seem to break without this...
    patchPhase = ''
      sed -i.bak -e '/"setuptools >= 21.2.1",/d' setup.py
    '';

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Packaging Helper";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      platforms = platforms.all;
    };
  };

in {

  www = pythonPackages.buildPythonPackage rec {
    name = "buildbot_www-${version}";
    version = "0.9.0rc2";

    # NOTE: wheel is used due to buildbot circular dependency
    format = "wheel";
    src = fetchurl {
      url = "https://pypi.python.org/packages/e0/d7/f1023cdb7340a15ee1fc9916e87c4d634405a87164a051e2c59bf9d51ef1/${name}-py2-none-any.whl";
      sha256 = "1006x56x4w4p2mbrzm7jy51c0xxz48lzhdwvx7j4hrjs07mapndj";
    };

    propagatedBuildInputs = [ buildbot-pkg ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot UI";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      platforms = platforms.all;
    };
  };

  console-view = pythonPackages.buildPythonPackage rec {
    name = "buildbot-console-view-${version}";
    version = "0.9.0rc2";

    src = fetchurl {
      url = "https://pypi.python.org/packages/ac/d4/33b0465d9e1c2d2d098bbf2b44067e7cb626fab89fe1af732143e4a2359f/${name}.tar.gz";
      sha256 = "41d6c276082a65d2a7d6c9f8fbc14c9f7a57f80ca6ffa09b111976e026ab9d3c";
    };

    propagatedBuildInputs = [ buildbot-pkg ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Console View Plugin";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      platforms = platforms.all;
    };
  };

  waterfall-view = pythonPackages.buildPythonPackage rec {
    name = "buildbot-waterfall-view-${version}";
    version = "0.9.0rc2";

    src = fetchurl {
      url = "https://pypi.python.org/packages/34/0b/267f65cf865f25b3616e3231111028181c6cc0c74d983ff17b98721a9992/${name}.tar.gz";
      sha256 = "1122f75ceac242d00dc10cdc381864e460b936532a1618bf47ce9b353a63814a";
    };

    propagatedBuildInputs = [ buildbot-pkg ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Waterfall View Plugin";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      platforms = platforms.all;
    };
  };
}
