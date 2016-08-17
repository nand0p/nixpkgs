{ stdenv,
  fetchurl,
  pythonPackages,
}:

pythonPackages.buildPythonApplication (rec {
  name = "buildbot-worker-${version}";
  version = "0.9.0rc1";

  src = fetchurl {
    url = "https://pypi.python.org/packages/98/9e/5ad4f156e719865fd31f880a18c44aa11bae5bfbbdc0fae4eb5694a6e9f5/${name}.tar.gz";
    sha256 = "5fc9bc888aee3af5e144c51a6c11d8f5afe57e459644749c66b495e82fba7e7e";
  };

  propagatedBuildInputs = with pythonPackages; [ twisted future setuptoolsTrial mock ];

  meta = with stdenv.lib; {
    homepage = http://buildbot.net/;
    description = "Buildbot Worker Daemon";
    maintainers = with maintainers; [ nand0p ryansydnor ];
    platforms = platforms.all;
  };
})
