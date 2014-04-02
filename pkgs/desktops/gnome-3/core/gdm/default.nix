{ stdenv, fetchurl, pkgconfig, glib, itstool, libxml2, xorg
, intltool, accountservice, libX11, autoreconfHook, gnome3, systemd
, gtk, libcanberra_gtk3, pam, libtool, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "gdm-3.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gdm/3.12/${name}.tar.xz";
    sha256 = "74889819a0c55577fd04236b5308de5f1fcf1992b221c71d02d91a1e564a5d87";
  };

  preAutoreconf = ''
    # GDM hardcodes the xserver path
    substituteInPlace ./configure.ac --replace "/usr/bin/X" "/var/lib/gdm/xserver-wrapper"

    # https://bugzilla.gnome.org/show_bug.cgi?id=725761
    substituteAllInPlace ./configure.ac --replace "AC_SUBST" "AS_AC_EXPAND"

    # Don't install a systemd service
    substituteInPlace ./data/Makefile.am --replace "systemdsystemunit += gdm.service" ""

    # Hardcoded pam check
    substituteInPlace ./data/Makefile.am --replace "/usr/include/security/pam_appl.h" "${pam}/include/security/pam_appl.h"
  '';

  configureFlags = [ "--with-systemd" "--with-default-pam-config=lfs" "--localstatedir=/var" ];

  # autoreconfHook needed to apply the expandvars patch
  buildInputs = [ pkgconfig glib itstool libxml2 intltool
                  accountservice autoreconfHook gnome3.dconf
                  gobjectIntrospection libX11 gtk systemd
                  libcanberra_gtk3 pam libtool ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GDM;
    platforms = platforms.linux;
  };
}
