{ stdenv, fetchurl, makeWrapper, perl, LWP, vorbisTools, flac }:

stdenv.mkDerivation rec {
  name = "lltag-${version}";
  version = "0.14.4";
  src = fetchurl {
    url = "http://download.gna.org/lltag/lltag-${version}.tar.bz2";
    sha256 = "13clxjbi7zzhnqnxwf9al3b8zk9klqgnzb20n1g3jdli529xks2z";
  };

  buildInputs = [ perl makeWrapper LWP ];

  postInstall = ''
    wrapProgram "$out/bin/lltag" \
      --prefix PATH : "${vorbisTools}/bin"
      --prefix PATH : "${flac}/bin"
    '';

  meta = {
    homepage = http://home.gna.org/lltag/;
    description = "Automatic command-line mp3/ogg/flac file tagger and renamer";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.bennofs ];
    platforms = stdenv.lib.platforms.linux;
  };
  
}