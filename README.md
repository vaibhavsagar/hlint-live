# hlint-live

This is a demonstration of HLint compiled to JavaScript via GHCJS and running
entirely in the browser.

To speed up building, you can use my cache at https://vaibhavsagar.cachix.org.

## development

```
$ nix-shell -A shells.ghc
[nix-shell] $ cd hlint-live
[nix-shell] $ runghc Setup.hs configure
[nix-shell] $ ghcid -T 'Main.main' --command 'runghc Setup.hs repl'
```
