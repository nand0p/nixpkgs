{ stdenv,
  fetchurl,
  buildPythonApplication,
  python
}:

{
  www = buildPythonApplication rec {
    name = "buildbot-www-0.9.0rc1";
    namePrefix = "";
    format = "wheel";

    src = fetchurl {
      url = "https://pypi.python.org/packages/f4/3c/8bf1add762739d1a15d63c91140d7fdc32d872860229ffdb10e735fdaa7a/buildbot_www-0.9.0rc1-py2-none-any.whl";
      sha256 = "21c3b55be0c1622757a04e6573e8503f2222ba80f01af3770eb04d71e3c5a8fb";
    };

    propagatedBuildInputs = [ python ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot UI";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      platforms = platforms.all;
    };
  };

  console-view = buildPythonApplication rec {
    name = "buildbot-console-view-0.9.0rc1";
    namePrefix = "";
    format = "wheel";

    src = fetchurl {
      url = "https://pypi.python.org/packages/2a/8c/797c1227159f18b9ffbaae0114ef0b8ae09b2df6f5f977378d16dc592f89/buildbot_console_view-0.9.0rc1-py2-none-any.whl";
      sha256 = "71c0c7ea8c95189d2934ab08d46f0340699999f4f01b952818ce4d23d3e12559";
    };

    propagatedBuildInputs = [ python ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Console View Plugin";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      platforms = platforms.all;
    };
  };

  waterfall-view = buildPythonApplication rec {
    name = "buildbot-waterfall-view-0.9.0rc1";
    namePrefix = "";
    format = "wheel";

    src = fetchurl {
      url = "https://pypi.python.org/packages/af/2b/959a2bf4f5c36a9d090a73814eacf6f0776fecfb0c9937a5c5b490bc8f84/buildbot_waterfall_view-0.9.0rc1-py2-none-any.whl";
      sha256 = "84da8fc2ed45a2ea3df5163c1f258724ff30ccf8b373052e8103ad40b87f6332";
    };

    propagatedBuildInputs = [ python ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Waterfall View Plugin";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      platforms = platforms.all;
    };
  };
}
