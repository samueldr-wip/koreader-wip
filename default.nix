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
      koreader-plugins = pkgs.callPackage ./pkgs/koreader/plugins.nix {
        inherit (final.koreader) src;
      };
    })
    (final: super: {
      # NOTE: pinning a local revision so local changes don't affect memoized third-party builds.
      koreader = super.koreader.overrideAttrs(_: {
        patches = [];
        src = builtins.fetchGit {
          url = ./koreader;
          rev = "e39624ffc55e535d11ed8b967bb5870b742a5a6d";
          submodules = true;
        };
      });
    })
  ]);

  my-plugins =
    pkgs.callPackage (
      { symlinkJoin, koreader-plugins }:
      symlinkJoin {
        name = "koreader-configured-plugins";
        paths = with koreader-plugins; [
          coverbrowser
          gestures
        ];
      }
    ) { }
  ;
in
  rec {
    inherit (pkgs) koreader;
    koreader-libs = (koreader.override({ buildMemoizedLibs = true; }));
    # This uses the memoized libraries from the "known good" revision.
    # Only changes to lua files will be built.
    koreader-recombined =
      (koreader.override({ memoizedLibBuild = koreader-libs; }))
      .overrideAttrs(_: {
        patches = [];
        src = builtins.fetchGit {
          url = ./koreader;
          submodules = true;
        };
      })
    ;
    configured-koreader = pkgs.callPackage (
      { symlinkJoin, koreader }:

      symlinkJoin {
        name = "koreader-configured";
        paths = [
          koreader
          my-plugins
          # TODO: allow easily replacing all useful lua files rather than re-compile the whole app
        ];

        postBuild = ''
          # Make the launcher scripts actual scripts.
          # This ensures BASH_SOURCE points to this directory, which in turn
          # is used to define KOREADER_DIR
          rm -vr $out/bin
          cp -vr ${koreader}/bin $out/bin
          chmod -R +w $out/bin

          # Make sure a koreader directory exists so KOREADER_DIR points to the
          # configured koreader even if no changes are configured.
          mkdir -p $out/lib/koreader

          # Make sure koreader uses the "configured" directory and not its actual derivation output...
          sed -i -e 's;^KOREADER_DIR=.*;KOREADER_DIR='"$out/lib/koreader"';' $out/bin/.koreader-wrapped
          substituteInPlace $out/bin/koreader \
            --replace "${koreader}" "$out"
        '';
      }
    ) {
      koreader = koreader-recombined;
    };
  }
