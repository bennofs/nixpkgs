{ lib, stdenv, fetchurl, dpkg, gawk, perl, wget, coreutils, util-linux
, gnugrep, gnutar, gnused, gzip, makeWrapper, bash }:
# USAGE like this: debootstrap sid /tmp/target-chroot-directory
# There is also cdebootstrap now. Is that easier to maintain?
let binPath = stdenv.lib.makeBinPath [
    coreutils
    dpkg
    gawk
    gnugrep
    gnused
    gnutar
    gzip
    perl
    wget
    util-linux
    bash
  ];
in stdenv.mkDerivation rec {
  pname = "debootstrap";
  version = "1.0.123";

  src = fetchurl {
    # git clone git://git.debian.org/d-i/debootstrap.git
    # I'd like to use the source. However it's lacking the lanny script ? (still true?)
    url = "mirror://debian/pool/main/d/${pname}/${pname}_${version}.tar.gz";
    sha256 = "0a53dhfwa74vdhqd6kbl7zlm7iic37c6wkdclppf0syxxi3q2njy";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;
  # the script is copied to the target chroot when using --foreign
  # since the target does not contain nix, we must avoid references to nx paths in the script
  dontPatchShebangs = true; 

  patches = [
     # fix hardcoded paths and permission issues 
    ./nix-patch.patch
  ];

  installPhase = ''
    runHook preInstall

    # NOTE: don't hardcode any absolute paths into the Nix store (see comment for dontPatchShebangs)
    # we can rely on PATH since we build a wrapper anyway
    substituteInPlace debootstrap \
      --subst-var-by VERSION ${version}

    d=$out/share/debootstrap
    mkdir -p $out/{share/debootstrap,bin}

    cp -r . $d

    # use makeWrapper and don't set argv0 so that $0 points to the unpatched script
    makeWrapper $out/share/debootstrap/debootstrap $out/bin/debootstrap \
      --set PATH ${binPath} \
      --set-default DEBOOTSTRAP_DIR $d

    mkdir -p $out/man/man8
    mv debootstrap.8 $out/man/man8

    rm -rf $d/debian

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to create a Debian system in a chroot";
    homepage = "https://wiki.debian.org/Debootstrap";
    license = licenses.mit;
    maintainers = with maintainers; [ marcweber ];
    platforms = platforms.linux;
  };
}
