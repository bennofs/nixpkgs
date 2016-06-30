{ fetchurl, jq }:

{ name
, version
, repository ? "https://crates.io/api/v1/crates"
, sha256
}:

fetchurl {
  name = "${name}-${version}.crate";
  url = "${repository}/${name}/${version}/download";
  inherit sha256;
}
