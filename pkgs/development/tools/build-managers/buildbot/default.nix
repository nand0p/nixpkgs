{ stdenv,
  lib,
  pythonPackages,
  fetchurl,
  coreutils,
  openssh,
  buildbot-worker,
  plugins ? [],
}:

pythonPackages.buildPythonApplication (rec {
  name = "${pname}-${version}";
  pname = "buildbot";
  version = "0.9.3";
  src = fetchurl {
    url = "mirror://pypi/b/${pname}/${name}.tar.gz";
    sha256 = "1yw7knk5dcvwms14vqwlp89flhjf8567l17s9cq7vydh760nmg62";
  };

  buildInputs = with pythonPackages; [
    lz4
    txrequests
    pyjade
    boto3
    moto
    txgithub
    mock
    setuptoolsTrial
    isort
    pylint
    astroid
    pyflakes
    openssh
    buildbot-worker
  ];

  propagatedBuildInputs = with pythonPackages; [

    # core
    twisted
    jinja2
    zope_interface
    future
    sqlalchemy
    sqlalchemy_migrate
    future
    dateutil
    txaio
    autobahn

    # tls
    pyopenssl
    service-identity
    idna

    # docs
    sphinx
    sphinxcontrib-blockdiag
    sphinxcontrib-spelling
    pyenchant
    docutils
    ramlfications
    sphinx-jinja

  ] ++ plugins;

  postPatch = ''
    # re-hardcode path to tail
    sed -i 's|/usr/bin/tail|${coreutils}/bin/tail|' buildbot/scripts/logwatcher.py
  '';

  postFixup = ''
    mv -v $out/bin/buildbot $out/bin/.wrapped-buildbot
    echo "#!/bin/sh" > $out/bin/buildbot
    echo "export PYTHONPATH=$PYTHONPATH" >> $out/bin/buildbot
    echo "exec $out/bin/.wrapped-buildbot \"\$@\"" >> $out/bin/buildbot
    chmod -c 555 $out/bin/buildbot
  '';

  meta = with stdenv.lib; {
    homepage = http://buildbot.net/;
    description = "Continuous integration system that automates the build/test cycle";
    maintainers = with maintainers; [ nand0p ryansydnor ];
    platforms = platforms.all;
    license = licenses.gpl2;
  };
})
