{ stdenv, fetchurl, vala, libxslt, pkgconfig, glib, dbus_glib, gnome3
, libxml2, intltool, docbook_xsl_ns, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "dconf-${version}";
  version = "0.20.0";

  src = fetchurl {
    url = "mirror://gnome/sources/dconf/0.20/${name}.tar.xz";
    sha256 = "22c046a247d05ea65ad181e3aef4009c898a5531f76c0181f8ec0dfef83447d9";
  };

  buildInputs = [ vala libxslt pkgconfig glib dbus_glib gnome3.gtk libxml2
                  intltool docbook_xsl docbook_xsl_ns ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Projects/dconf;
    platforms = platforms.linux;
  };
}
