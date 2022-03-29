{ system ? builtins.currentSystem
, pkgs ? import ./pkgs.nix { inherit system; }
}:

# Break reference cycle
let pkgs' = pkgs; in
let

  pkgs = pkgs'.appendOverlays([
    (final: super: {
      koreader = final.callPackage ./pkgs/koreader {
        luaPackages = final.luajitPackages;
        luarocks = final.luajitPackages.luarocks;
      };
    })
  ]);

in
  pkgs.koreader
