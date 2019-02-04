{ stdenv, lib, fetchFromGitHub, python3, breakpointHook }:

let
  djangoEnv = python3.override {
    packageOverrides = self: super: {
      django = super.django_2_0;
    };
  };
  py = djangoEnv.withPackages (ps: with ps; [
    django django-cors-headers djangorestframework drf-nested-routers pytz django-etesync-journal
  ]);
in stdenv.mkDerivation {
  pname = "etesync-server";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "server-skeleton";
    rev = "9536bed501eae3b99cba39112177d0f4ced57682";
    sha256 = "sha256:11m9k07hf7q8k2zwwfpb93h1p5dffm7h3g6f6pavrz742xgpv9pj";
  };
  buildInputs = [ py ];

  installPhase = ''
    mkdir -p $out
    cp -r {manage.py,etesync_server} $out/
    cp ${./etesync_site_settings.py} $out/etesync_site_settings.py
    patchShebangs $out/

    export ETESYNC_SECRET_FILE=$PWD/secret.txt
    $out/manage.py collectstatic
  '';

  meta = with lib; {
    description = "A basic EteSync service (so you can run your own)";
    homepage = https://www.etesync.com/;
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.bennofs ];
    platforms = platforms.all;
  };
}
