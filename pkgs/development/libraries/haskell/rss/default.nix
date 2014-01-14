{ cabal, HaXml, network, time }:

cabal.mkDerivation (self: {
  pname = "rss";
  version = "3000.2.0.2";
  sha256 = "0lj5a91p74b3rq4d5gjkjhp3mwy74140cd8sp8kslmifpr483s40";
  buildDepends = [ HaXml network time ];
  meta = {
    homepage = "https://github.com/basvandijk/rss";
    description = "A library for generating RSS 2.0 feeds.";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
  };
  jailbreak = true;
})
