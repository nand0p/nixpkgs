{ stdenv,
  fetchurl,
  pythonPackages,
}:

pythonPackages.buildPythonApplication (rec {
  name = "${pname}-0.8.14";
  pname = "buildbot";
  version = "0.8.14";

  src = fetchurl {
    url = "mirror://pypi/b/${pname}/${name}.tar.gz";
    sha256 = "0r79fs305qdr2rjfg3kpip4350ypx00qh9gvm0ic48kmpl3zs7ik";
  };

  propagatedBuildInputs = with pythonPackages;
    [ twisted
      dateutil
      jinja2
      sqlalchemy_migrate
      pysqlite
      setuptoolsTrial
      txrequests
      txgithub
    ];

  patchPhase = ''
    sed -i 's/<=/>=/' setup.py
    sed -i 's/==/>=/' setup.py
  '';

  doCheck = false;
  #twisted.trial.unittest.FailTest: 0 != 1

  postInstall = ''
    mkdir -p "$out/share/man/man1"
    cp docs/buildbot.1 "$out/share/man/man1"
  '';

  meta = with stdenv.lib; {
    homepage = http://buildbot.net/;
    license = licenses.gpl2Plus;
    description = "Continuous integration system that automates the build/test cycle";
    maintainers = with maintainers; [ bjornfor nand0p ];
    platforms = platforms.all;
  };
})
