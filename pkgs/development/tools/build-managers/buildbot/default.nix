{ stdenv,
  pythonPackages,
  fetchurl,
  twisted,
  jinja2,
  plugins ? []
}:

pythonPackages.buildPythonApplication (rec {
  name = "buildbot-${version}";
  version = "0.9.0rc1";

  src = fetchurl {
    url = "mirror://pypi/b/buildbot/${name}.tar.gz";
    sha256 = "09xsagnfxb8p4a5rqjl69l2q09gnxrba705z8a6sv0jc973c92gh";
  };

  propagatedBuildInputs = with pythonPackages; [
    twisted
    dateutil
    jinja2
    sqlalchemy
    sqlalchemy_migrate
    zope_interface
    future
    dateutil
    autobahn
    plugins
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://buildbot.net/;
    description = "Continuous integration system that automates the build/test cycle";
    maintainers = with maintainers; [ nand0p ];
    platforms = platforms.all;
  };
})
