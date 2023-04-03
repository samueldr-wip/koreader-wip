{ system ? builtins.currentSystem
, pkgs ? import ./pkgs.nix { inherit system; }
}:

# Break reference cycle
let pkgs' = pkgs; in

let
  pkgs = pkgs'.appendOverlays([
    (final: super: {
      koreader = final.callPackage ./pkgs/koreader {
        # ¯\_(ツ)_/¯
        # Their luajit fails on aarch64 when built with gcc12.
        # `table overflow` at unrelated(?) locations.
        stdenv = final.gcc9Stdenv;
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
          # XXX when hacking on lua, use rev
          rev = "e39624ffc55e535d11ed8b967bb5870b742a5a6d";
          submodules = true;
        };
      })
    ;
    configured-koreader = pkgs.callPackage (
      { symlinkJoin, koreader, additionalPaths ? [] }:

      symlinkJoin {
        name = "koreader-configured";
        paths = additionalPaths ++ [
          my-plugins
          koreader
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
      additionalPaths = [ luaBits ];
    };
    luaBits = pkgs.callPackage (
      { runCommand }:
      runCommand "koreader-wip-lua-bits" {
        src = builtins.fetchGit {
          url = ./koreader;
          submodules = true;
        };
      } ''
        (
        PS4=" $ "
        set -x
        mkdir -p $out/lib/koreader/
        cp -rvt $out/lib/koreader/ \
          $src/*.lua \
          $src/frontend
        )
      ''
    ) {  };
  }
