with (import <nixpkgs> {});

rec {
  fetchcrate = callPackage ./fetchcrate {};
  mkDerivation = callPackage ./generic-builder { inherit fetchcrate; };
  hello_rusty_worlds = callPackage ./hello-rusty-worlds.nix {
    inherit mkDerivation;
  };
  test-case = callPackage ./test-case.nix { inherit mkDerivation hello_rusty_worlds; };
  cfg = callPackage ./cfg.nix {};
}
