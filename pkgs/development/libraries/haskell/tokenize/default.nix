{ cabal, split }:

cabal.mkDerivation (self: {
  pname = "tokenize";
  version = "0.1.3";
  sha256 = "1yk0nndggywhs6dghmf3yrcdgjjk8f3k613wa0q73bpia232dpx6";
  buildDepends = [ split ];
  meta = {
    homepage = "https://bitbucket.org/gchrupala/lingo/overview";
    description = "Simple tokenizer for English text";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
