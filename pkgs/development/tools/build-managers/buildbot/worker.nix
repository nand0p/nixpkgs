{ stdenv, fetchurl, pythonPackages, gnused, coreutils }:

pythonPackages.buildPythonApplication (rec {
  name = "${pname}-${version}";
  pname = "buildbot-worker";
  version = "0.9.3";

  src = fetchurl {
    url = "mirror://pypi/b/${pname}/${name}.tar.gz";
    sha256 = "176kp04g4c7gj15f73wppraqrirbfclyx214gcz966019niikcsp";
  };

  postPatch = ''
    # re-hardcode path to tail
    ${gnused}/bin/sed -i 's|/usr/bin/tail|${coreutils}/bin/tail|' buildbot_worker/scripts/logwatcher.py
  '';

  postFixup = ''
    mv -v $out/bin/buildbot-worker $out/bin/.wrapped-buildbot-worker
    echo "#!/bin/sh" > $out/bin/buildbot-worker
    echo "export PYTHONPATH=$PYTHONPATH" >> $out/bin/buildbot-worker
    echo "exec $out/bin/.wrapped-buildbot-worker \"\$@\"" >> $out/bin/buildbot-worker
    chmod -c 555 $out/bin/buildbot-worker
  '';

  buildInputs = with pythonPackages; [ setuptoolsTrial mock ];
  propagatedBuildInputs = with pythonPackages; [ twisted future ];

  meta = with stdenv.lib; {
    homepage = http://buildbot.net/;
    description = "Buildbot Worker Daemon";
    maintainers = with maintainers; [ nand0p ryansydnor ];
    platforms = platforms.all;
    license = licenses.gpl2;
  };
})
