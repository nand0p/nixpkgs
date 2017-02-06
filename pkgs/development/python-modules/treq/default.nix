{ stdenv, fetchurl, buildPythonPackage, service-identity,
  requests2, twisted, incremental }:

buildPythonPackage rec {
   name = "${pname}-${version}";
   pname = "treq";
   version = "16.12.0";

   src = fetchurl {
     url = "mirror://pypi/t/${pname}/${name}.tar.gz";
     sha256 = "1aci3f3rmb5mdf4s6s4k4kghmnyy784cxgi3pz99m5jp274fs25h";
   };

   propagatedBuildInputs = [
     service-identity
     requests2
     twisted
     incremental
   ];

   meta = with stdenv.lib; {
     homepage = http://github.com/twisted/treq;
     description = "A requests-like API built on top of twisted.web's Agent";
     license = licenses.mit;
     maintainers = maintainers.nando0p;
   };
}
