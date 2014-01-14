{ cabal, acidState, aeson, alex, async, attoparsec
, base16Bytestring, base64Bytestring, binary, blazeBuilder, Cabal
, cereal, cryptoApi, csv, deepseq, filepath, happstackServer
, happy, hscolour, hslogger, HStringTemplate, HTTP, liftedBase
, mimeMail, mtl, network, parsec, pureMD5, random, rss, safecopy
, snowball, split, stm, tar, text, time, tokenize, transformers
, unorderedContainers, vector, xhtml, zlib
}:

cabal.mkDerivation (self: {
  pname = "hackage-server";
  version = "0.4";
  sha256 = "1smihrkibg16b3y0v5fr7hm3klp3j131mclh11jc6w9k5szcjrki";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    acidState aeson async attoparsec base16Bytestring base64Bytestring
    binary blazeBuilder Cabal cereal cryptoApi csv deepseq filepath
    happstackServer hscolour hslogger HStringTemplate HTTP liftedBase
    mimeMail mtl network parsec pureMD5 random rss safecopy snowball
    split stm tar text time tokenize transformers unorderedContainers
    vector xhtml zlib
  ];
  testDepends = [
    base64Bytestring Cabal filepath HTTP network tar zlib
  ];
  buildTools = [ alex happy ];
  meta = {
    description = "The Hackage web server";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
  jailbreak = true;
})
