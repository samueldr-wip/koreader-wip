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

  plugins = pkgs.runCommandNoCC "koreader-configured-plugins" {} ''
    mkdir -p $out/lib/koreader/plugins
    PLUGINS=(
      coverbrowser
      gestures
    )
    for p in "''${PLUGINS[@]}"; do
      cp -prf ${pkgs.koreader.src}/plugins/$p.koplugin $out/lib/koreader/plugins/$p.koplugin
    done
  '';

  inherit (pkgs)
    koreader
  ;
in
  pkgs.symlinkJoin {
    name = "koreader-configured";
    paths = [
      koreader
      plugins
    ];

    # Make the launcher scripts actual scripts.
    # This ensures BASH_SOURCE points to this directory, which in turn
    # is used to define KOREADER_DIR
    postBuild = ''
      rm -vr $out/bin
      cp -vr ${koreader}/bin $out/bin
      chmod -R +w $out/bin

      # Make sure a koreader directory exists so KOREADER_DIR points to the
      # configure koreader even if no changes are configured.
      mkdir -p $out/lib/koreader

      # Make sure koreader uses the "configured" directory and not its actual derivation output...
      sed -i -e 's;^KOREADER_DIR=.*;KOREADER_DIR='"$out/lib/koreader"';' $out/bin/.koreader-wrapped
      substituteInPlace $out/bin/koreader \
        --replace "${koreader}" "$out"
    '';
  }
