{ lib, git }:

let
  registryConfig = ''
    {
      "dl": "http://error-registry-download-uri-should-not-be-accessed",
      "api": "http://error-registry-api-uri-should-not-be-accessed"
    }
  '';

  makeGitRepo = ''
    ${git}/bin/git init
    ${git}/bin/git add .
    ${git}/bin/git config user.name "Nix Builder"
    ${git}/bin/git config user.email nixbld@example.org
    ${git}/bin/git commit -m "nix fake rust registry initial commit"
  '';

  registryPath = name:
    let len = builtins.stringLength name;
    in
      if len < 3 then "${toString len}/name"
      else if len == 3 then "3/${builtins.substring 0 1 name}/${name}"
      else "${builtins.substring 0 2 name}/${builtins.substring 2 2 name}/${name}";

  depInfo = optional: kind: dep: {
    inherit kind optional;
    inherit (dep.meta.rust) name;
    req = "=" + dep.meta.rust.version;
    features = dep.meta.rust.extraFeatures;
    default_features = dep.meta.rust.useDefaultFeatures;
    target = null;
  };

  packageInfo = pkg: builtins.toJSON {
    inherit (pkg.meta.rust) name cksum yanked;
    vers = pkg.meta.rust.version;
    features = pkg.meta.rust.providedFeatures;
    deps = lib.concatLists [
      (map (depInfo false "normal") pkg.meta.rust.rustDepends)
      (map (depInfo false "dev") pkg.meta.rust.devRustDepends)
      (map (depInfo true "normal") pkg.meta.rust.optionalRustDepends)
    ];
  };

  registerPackage = pkg: ''
    mkdir -p "$(dirname "${registryPath pkg.meta.rust.name}")"
    echo '${packageInfo pkg}' >> "${registryPath pkg.meta.rust.name}"
  '';

  buildIndex = pkgs: ''
    echo '${registryConfig}' > config.json
    ${lib.concatStringsSep "\n" (map registerPackage pkgs)}
    ${makeGitRepo}
  '';

  cachePackage = pkg: ''
    echo 1 > ${pkg.name}.crate
  '';

  buildCache = pkgs: lib.concatStringsSep "\n" (map cachePackage pkgs);

  unpackPackage = pkg: ''
    mkdir -p ${pkg.name}
    touch ${pkg.name}/.cargo-ok
  '';

  buildSrc = pkgs: lib.concatStringsSep "\n" (map unpackPackage pkgs);

  buildRegistry = pkgs: ''
    cat <<EOF > $CARGO_HOME/config
    [registry]
    index = "file://$PWD/index/git"
    EOF

    mkdir -p index/git
    (
      cd index/git
      ${buildIndex pkgs}
    )

    (
      cd $NIX_BUILD_TOP
      env USER=nixbld cargo init registry-init-crate
      cd registry-init-crate
      echo 'dummy = "0.1.0"' >> Cargo.toml
      cargo generate-lockfile --verbose 2>/dev/null || true
    )

    if ! registryHash=$(find index -mindepth 1 -maxdepth 1 -type d -printf "%f" -quit 2> /dev/null)
    then
      registryHash="empty-registry"
    fi

    mkdir -p cache/$registryHash
    (
      cd cache/$registryHash
      ${buildCache pkgs}
    )

    mkdir -p src/$registryHash
    (
      cd src/$registryHash
      ${buildSrc pkgs}
    )

    echo "$registryHash" > $CARGO_HOME/registry-hash
  '';

in buildRegistry
