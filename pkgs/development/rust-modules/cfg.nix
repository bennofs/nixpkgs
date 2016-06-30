# This nix file parses the result of `rustc --print=cfg` and makes it available for
# nix expressions. This is required because cargo supports conditionals based on rust
# cfg syntax, and to resolve these, we need to know what cfg the rust compiler uses.
{ runCommand, rustc }:

let

  # This sed script will transform the output of `rustc --cfg` into a valid nix expression.
  # `rustc --cfg` produces text that looks like this:
  #
  #     target_os="linux"
  #     target_family="unix"
  #     target_arch="x86_64"
  #     target_endian="little"
  #     target_pointer_width="64"
  #     target_env="gnu"
  #     unix
  #     debug_assertions
  #
  # The sed script will turn that into:
  #
  #     {
  #     "target_os"="linux";
  #     "target_family"="unix";
  #     "target_arch"="x86_64";
  #     "target_endian"="little";
  #     "target_pointer_width"="64";
  #     "target_env"="gnu";
  #     "unix"=true;
  #     "debug_assertions"=true;
  #     }
  cfg_to_nix = ''
    # Inserts a { at the beginning of the file
    1 i{

    # Appends a } to the end of the file
    $ a}

    # Transforms foo="bar" lines into "foo"="bar"; lines
    s/^(.*?)="(.*?)"$/"\1"="\2";/

    # Transforms foo lines into "foo"=true; lines
    s/^([^=]*)$/"\1"=true;/
  '';

  # Derivation to generate the nix expression representing the rust cfg values
  expr = runCommand "cfg-${rustc.name}.nix" {} ''
    ${rustc}/bin/rustc --print=cfg | sed -re '${cfg_to_nix}' > $out;
  '';

# Using the "import-from-derivation" feature, we can import the nix expression generated
# by that expression.
in import expr
