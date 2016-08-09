{ stdenv,
  fetchurl,
  pythonPackages
}:

let
  buildbot-pkg = pythonPackages.buildPythonPackage rec {
    name = "buildbot-pkg-0.9.0rc1";
    version = "0.9.0rc1";

    src = fetchurl {
      url = "https://pypi.python.org/packages/8f/37/6de8734299b94c6d853d2380f0a2cdadf00d24bbac6b8947ea2d3848d15d/buildbot-pkg-0.9.0rc1.tar.gz";
      sha256 = "0bbbf10361087493cc6ee62e077863eafe1b3e24c43a8429a6eb1a75b35359b6";
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
    name = "buildbot-www-0.9.0rc1";
    version = "0.9.0rc1";
    format = "wheel";

    src = fetchurl {
      url = "https://pypi.python.org/packages/f4/3c/8bf1add762739d1a15d63c91140d7fdc32d872860229ffdb10e735fdaa7a/buildbot_www-0.9.0rc1-py2-none-any.whl";
      sha256 = "21c3b55be0c1622757a04e6573e8503f2222ba80f01af3770eb04d71e3c5a8fb";
    };

    propagatedBuildInputs = [ pythonPackages.python ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot UI";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      platforms = platforms.all;
    };
  };

  console-view = pythonPackages.buildPythonPackage rec {
    name = "buildbot-console-view-0.9.0rc1";
    version = "0.9.0rc1";

    src = fetchurl {
      url = "https://pypi.python.org/packages/ac/d4/33b0465d9e1c2d2d098bbf2b44067e7cb626fab89fe1af732143e4a2359f/buildbot-console-view-0.9.0rc1.tar.gz";
      sha256 = "4cd6c276082a65d2a7d6c9f8fbc14c9f7a57f80ca6ffa09b111976e026ab9d3c";
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
    name = "buildbot-waterfall-view-0.9.0rc1";
    version = "0.9.0rc1";

    src = fetchurl {
      url = "https://pypi.python.org/packages/34/0b/267f65cf865f25b3616e3231111028181c6cc0c74d983ff17b98721a9992/buildbot-waterfall-view-0.9.0rc1.tar.gz";
      sha256 = "8822f75ceac242d00dc10cdc381864e460b936532a1618bf47ce9b353a63814a";
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
