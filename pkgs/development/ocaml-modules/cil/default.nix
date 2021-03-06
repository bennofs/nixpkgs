{ lib, stdenv, fetchurl, perl, ocaml, findlib, ocamlbuild }:

if stdenv.lib.versionAtLeast ocaml.version "4.06"
then throw "cil is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation {
  name = "ocaml-cil-1.7.3";
  src = fetchurl {
    url = "mirror://sourceforge/cil/cil-1.7.3.tar.gz";
    sha256 = "05739da0b0msx6kmdavr3y2bwi92jbh3szc35d7d8pdisa8g5dv9";
  };

  buildInputs = [ perl ocaml findlib ocamlbuild ];

  createFindlibDestdir = true;

  preConfigure = ''
    substituteInPlace Makefile.in --replace 'MACHDEPCC=gcc' 'MACHDEPCC=$(CC)'
    export FORCE_PERL_PREFIX=1
  '';
  prefixKey = "-prefix=";

  meta = with lib; {
    homepage = "http://kerneis.github.io/cil/";
    description = "A front-end for the C programming language that facilitates program analysis and transformation";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
