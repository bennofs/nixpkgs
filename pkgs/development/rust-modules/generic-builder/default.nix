{ stdenv, fetchcrate, cargo, rustc, git, tree }:

{ name
, version
, sha256 ? null
, src ? fetchcrate { inherit name version sha256; }
, rustDepends ? []
, devRustDepends ? []
, targetRustDepends ? []
, providedFeatures ? {}
, useDefaultFeatures ? true
, extraFeatures ? []
, yanked ? false
, meta ? { description = ""; license = null; }
}:

let
  cargoFlags = stdenv.lib.concatStringsSep " " [
    (stdenv.lib.optionalString (!useDefaultFeatures) "--no-default-features")
    "--features=${stdenv.lib.concatStringsSep " " extraFeatures}"
  ];
  buildFlags = stdenv.lib.concatStringsSep " " [
    cargoFlags
    "--release"
  ];
  isRustPkg = pkg: stdenv.lib.isDerivation pkg && pkg ? meta && pkg.meta ? rust;
  optionalRustDepends = builtins.filter isRustPkg (stdenv.lib.attrValues providedFeatures);
  buildRegistry = import ./build-registry.nix {
    inherit git;
    inherit (stdenv) lib;
  };
  buildCache = import ./build-cache.nix { inherit (stdenv) lib; };
  linkDeps = import ./link-deps.nix { inherit (stdenv) lib; };
  rustInputs = rustDepends ++ devRustDepends;
in

stdenv.mkDerivation {
  name = "${name}-${version}";
  inherit src;

  buildInputs = [ cargo rustc tree ];

  preUnpack = ''
    function unpack() {
      case "$1" in
        *.crate)
          tar -xf "$1"
          ;;
        *)
          return 1
          ;;
      esac
    }
    unpackCmdHooks+=(unpack)
  '';

  configurePhase = ''
    export CARGO_HOME="$NIX_BUILD_TOP/cargo"
    mkdir -p target/release $CARGO_HOME/registry

    (
      cd "$CARGO_HOME/registry"
      ${buildRegistry rustInputs}
    )

    mkdir -p target/release
    (
      cd target/release
      ${linkDeps rustInputs}
    )
  '';

  buildPhase = ''
    cargo build ${buildFlags}
  '';

  installPhase = ''
    # Install binaries
    cargo install --root $out ${cargoFlags}

    # Install libraries
    mkdir -p $out/rust/lib $out/rust/fingerprint
    find target/release -maxdepth 1 -name "*.rlib" -exec cp -v '{}' "$out/rust/lib" ';'
    cp target/release $out -r
    find target/release/.fingerprint/ -mindepth 1 -maxdepth 1 -type d -not -type l \
      -exec cp -rv '{}' "$out/rust/fingerprint" ';'
    find $out/rust/fingerprint -name "*test-*" -exec rm '{}' '+'
  '';

  checkPhase = ''
    cargo test ${buildFlags}
  '';
  doCheck = true;

  meta = meta // {
    rust = {
      inherit
        useDefaultFeatures extraFeatures name version yanked providedFeatures
        rustDepends devRustDepends optionalRustDepends;
      cksum = sha256;
    };
  };

  shellHook = ''
    mkdir -p $NIX_BUILD_TOP/1
    export NIX_BUILD_TOP=$NIX_BUILD_TOP/1
    cd $NIX_BUILD_TOP
    rm * -rf
    unpackPhase
    cd $sourceRoot
    export HOME=$NIX_BUILD_TOP
    eval "$configurePhase"
  '';
}
