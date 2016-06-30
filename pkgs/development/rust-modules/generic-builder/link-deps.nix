{ lib }:

let
  linkDep = dep: ''
    find ${dep}/rust/lib -type f -exec ln -s {} deps \;
    find ${dep}/rust/fingerprint -maxdepth 1 -mindepth 1 -type d -exec ln -s {} .fingerprint \;
  '';
  linkDeps = deps: ''
    mkdir -p deps .fingerprint
    ${lib.concatStringsSep "\n" (map linkDep deps)}
  '';
in linkDeps
