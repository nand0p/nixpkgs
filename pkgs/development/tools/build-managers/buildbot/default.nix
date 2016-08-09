{ stdenv,
  pythonPackages,
  fetchurl,
  plugins ? []
}:

pythonPackages.buildPythonApplication (rec {
  name = "${pname}-${version}";
  pname = "buildbot";
  version = "0.9.0rc1";

  src = fetchurl {
    url = "mirror://pypi/b/${pname}/${name}.tar.gz";
    sha256 = "09xsagnfxb8p4a5rqjl69l2q09gnxrba705z8a6sv0jc973c92gh";
  };

  propagatedBuildInputs = with pythonPackages; [
    twisted
    lz4
    txrequests
    dateutil
    jinja2
    sqlalchemy
    sqlalchemy_migrate
    zope_interface
    future
    dateutil
    autobahn
    plugins
    setuptoolsTrial
    ramlfications
    txgithub
  ];

  preInstall = ''
    # buildbot tries to import 'buildslaves' but does not
    # include the module in it's package, so get rid of those references
    sed -i.bak -e '66,$d' buildbot/test/__init__.py
    sed -i.bak -e '506,$d' buildbot/test/unit/test_worker_base.py
    sed -i.bak -e '648,$d' buildbot/test/unit/test_worker_ec2.py
    sed -i.bak -e '289,$d' buildbot/test/unit/test_worker_libvirt.py
    sed -i.bak -e '190,$d' buildbot/test/unit/test_worker_openstack.py
    sed -i.bak -e '60,84d' buildbot/test/integration/test_configs.py

    # writes out a file that can't be read properly
    sed -i.bak -e '69,84d' buildbot/test/unit/test_www_config.py

  '';

  meta = with stdenv.lib; {
    homepage = http://buildbot.net/;
    description = "Continuous integration system that automates the build/test cycle";
    maintainers = with maintainers; [ nand0p ryansydnor ];
    platforms = platforms.all;
  };
})
