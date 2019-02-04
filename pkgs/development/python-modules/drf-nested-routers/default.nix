{ stdenv
, buildPythonPackage
, fetchPypi
, django
, djangorestframework
}:

buildPythonPackage rec {
  version = "0.91";
  pname = "drf-nested-routers";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d2hb2jdm8s8pfdmkqr8cay1n4prx0l51mypmypjqy2wq6mw7ra6";
  };

  propagatedBuildInputs = [ django djangorestframework ];

  # the pypi distribution does not incldude any tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/alanjds/drf-nested-routers;
    description = "Nested Routers for Django Rest Framework";
    license = licenses.asl20;
    maintainers = [ maintainers.bennofs ];
  };
}
