{ mkDerivation, hello_rusty_worlds }:

mkDerivation {
  name = "test-case";
  version = "0.1.0";
  src = ./test-case;

  rustDepends = [ hello_rusty_worlds ];
}
