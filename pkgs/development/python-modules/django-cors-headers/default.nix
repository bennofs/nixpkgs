{ stdenv
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  version = "2.4.0";
  pname = "django-cors-headers";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qfa9awsj3f0nwygb0vdh4ilcsfi6zinzng73cd5864x2fbyxhn4";
  };

  propagatedBuildInputs = [ django ];

  # the pypi distribution does not incldude any tests
  doCheck = false;


  meta = with stdenv.lib; {
    homepage = https://github.com/ottoyiu/django-cors-headers;
    description = "Django app for handling the server headers required for Cross-Origin Resource Sharing (CORS)";
    license = licenses.mit;
    maintainers = [ maintainers.bennofs ];
  };
}
