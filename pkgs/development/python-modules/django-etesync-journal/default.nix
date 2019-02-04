{ stdenv
, buildPythonPackage
, fetchPypi
, django
, djangorestframework
, drf-nested-routers
}:

buildPythonPackage rec {
  version = "0.5.4";
  pname = "django-etesync-journal";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fjgrjqiqhg7d797g17wgmzxqmdikvjv71zhlsdlwscirx70wwpx";
  };

  propagatedBuildInputs = [ django djangorestframework drf-nested-routers ];
  checkPhase = ''
  # the tests need to run in $out else they fail with:
  #   ImportError: 'test_settings' module incorrectly imported from '/nix/store/bmbj6skwislfbs2p9xpfmzm470hpk0nj-python3.7-django-etesync-journal-0.5.4/lib/python3.7/site-packages/tests'.
  #   Expected '/tmp/nix-build-python3.7-django-etesync-journal-0.5.4.drv-0/django-etesync-journal-0.5.4/tests'. Is this module globally installed?
  cd $out
  export DJANGO_SETTINGS_MODULE=tests.test_settings
  ${django}/bin/django-admin.py test
  '';

  meta = with stdenv.lib; {
    homepage = https://www.etesync.com/;
    description = "Reusable django app that implements the server side of EteSync";
    license = licenses.agpl3;
    maintainers = [ maintainers.bennofs ];
  };
}
