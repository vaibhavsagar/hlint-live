let
  # ./updater versions.json reflex-platform
  fetcher = { owner, repo, rev, sha256, ... }: builtins.fetchTarball {
    inherit sha256;
    url = "https://github.com/${owner}/${repo}/tarball/${rev}";
  };
  reflex-platform = fetcher (builtins.fromJSON (builtins.readFile ./versions.json)).reflex-platform;
in (import reflex-platform { system = builtins.currentSystem; }).project ({ pkgs, ... }: {
  overrides = self: super: {
    hlint = pkgs.haskell.lib.overrideCabal (self.callHackage "hlint" "3.3.6" {}) (drv: {
      configureFlags = (drv.configureFlags or []) ++ [ "-fhsyaml" ];
      buildDepends = (drv.buildDepends or []) ++ [ self.HsYAML self.HsYAML-aeson ];
      postPatch = (drv.postPatch or "") + ''
        substituteInPlace src/CmdLine.hs --replace \
          "import System.FilePath" \
          "import System.FilePath hiding (isWindows)"
      '';
    });
    hpc = pkgs.haskell.lib.doJailbreak (self.callHackage "hpc" "0.6.0.3" {});
    ghc-lib-parser = pkgs.haskell.lib.dontHaddock (self.callHackage "ghc-lib-parser" "9.0.2.20211226" {});
    ghc-lib-parser-ex = self.callHackage "ghc-lib-parser-ex" "9.0.0.6" {};
  };
  useWarp = true;
  withHoogle = false;
  packages = {
    hlint-live = ./hlint-live;
  };
  shells = {
    ghc8_10 = ["hlint-live"];
    ghcjs8_10 = ["hlint-live"];
  };
})
