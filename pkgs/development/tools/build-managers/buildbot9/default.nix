{ stdenv,
  buildPythonApplication,
  python,
  fetchurl,
  twisted,
  jinja2,
  sqlalchemy,
  sqlalchemy_migrate,
  zope_interface,
  future,
  dateutil,
  autobahn,
  plugins ? []
}:

buildPythonApplication (rec {
  name = "buildbot-0.9.0rc1";
  namePrefix = "";

  src = fetchurl {
    url = "https://pypi.python.org/packages/1b/d0/419ec2d6e0e75e4fbeb766d662dedfd9c1186b1c87b54d1f93d511abe78c/buildbot-0.9.0rc1.tar.gz";
    sha256 = "f089c4c6494c82ad8d42bf80a356eef62580054d864a9c8b2217adeeec53ba27";
  };

  propagatedBuildInputs =
    [
      python
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
