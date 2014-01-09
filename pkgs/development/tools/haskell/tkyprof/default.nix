{ cabal, aeson, attoparsec, attoparsecConduit, blazeBuilder
, cmdargs, conduit, dataDefault, filepath, hamlet, httpTypes, mtl
, resourcet, rosezipper, shakespeareCss, shakespeareJs, stm, text
, time, transformers, unorderedContainers, vector, wai, waiExtra
, warp, webRoutes, yesod, yesodCore, yesodForm, yesodStatic
}:

cabal.mkDerivation (self: {
  pname = "tkyprof";
  version = "0.2.1.1";
  sha256 = "1h4wz49bj5kj0ip9fcl4prshqag9jg4bwpvva7gaxdna10m32vvi";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec attoparsecConduit blazeBuilder cmdargs conduit
    dataDefault filepath hamlet httpTypes mtl resourcet rosezipper
    shakespeareCss shakespeareJs stm text time transformers
    unorderedContainers vector wai waiExtra warp webRoutes yesod
    yesodCore yesodForm yesodStatic
  ];
  meta = {
    homepage = "https://github.com/maoe/tkyprof";
    description = "A web-based visualizer for GHC Profiling Reports";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
