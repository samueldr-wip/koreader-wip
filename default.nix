{ pkgs ? import <nixpkgs> {} }:

pkgs.callPackage (
  { stdenv
  , lib
  , buildPackages
  , fetchurl
  , fetchFromGitHub
  , fetchFromGitLab

  , git # FIXME: shim that tattles on commands being ran
  , util-linux # for getopt
  , which

  # Build dependencies
  , cmake
  , autoconf
  , automake
  , libtool
  , autoconf-archive
  , pkg-config
  , perl
  , luarocks
  , python27

  , ragel

  # Third party deps
  , freetype
  , luaPackages

  # Misc dependencies

  , gettext
  , zlib

  # For mupdf
  , jbig2dec
  , openjpeg
  }:

  let
    inherit (lib)
      concatMapStringsSep
    ;

    deps =
      # Can't use `callPackage` as it wraps the attrset and adds a few attributes.
      # Could be fixed by having the deps in a wrapper attrset.
      let deps = (import ./deps.nix {
        inherit
          fetchFromGitLab
          fetchFromGitHub
          fetchurl
        ;
      });
      in
      deps // {
        # Override the downstream one; the source selected doesn't build due to
        # dependency on submodules (even when checking out with submodules)
        freetype2 = freetype;
      }
    ;

    # TODO: include in deps somehow
    crengine = {
      src = fetchFromGitHub {
        owner = "koreader";
        repo = "crengine";
        rev = "b0fdab357637e9b3aa407e5dfa102adc3c303f68";
        hash = "sha256-5poGUwXkllgE+kYAtLFMLb9r3FOTpJ6OAQhHu7sp3o8=";
      };
    };
    # TODO: include in deps somehow
    inherit (luaPackages) luafilesystem;

  in
  # XXX : replace /build/source with the proper env var
  stdenv.mkDerivation {
    pname = "koreader";
    version = "v2022.03.1";

    postPatch = ''
      third-party-dir() {
        local name="$1"; shift
        echo "/build/source/base/thirdparty/$name/build/${stdenv.hostPlatform.config}-debug/$name-prefix/src"
      }
      copy-third-party() {
        local name="$1"; shift
        local src="$1"; shift

        local dir="$(third-party-dir "$name")"

        echo ":: Adding thirdparty: $name"
        mkdir -p "$dir"

        if [ -d "$src" ]; then
          (
          cp -rf \
            "$src" \
            $dir/$name
          chmod -R +w $dir
          )
        else
          case "$src" in
            *.tar.gz|*.tar.xz|*.tar.bz2)
              (
                cd $dir
                tar xf "$src"
                mv * "$name"
              )
            ;;
            *)
              echo "Don't know how to extract '$src'"
              exit 1
            ;;
          esac
        fi
      }

      # Submodules for "koreader-base"
      echo ":: Copying submodules for koreader-base"
      (
        cd base
        cp -rf "${luafilesystem.src}" "luafilesystem"
        chmod -R +w "luafilesystem"

        mkdir -p kpvcrlib
        cp -rf "${crengine.src}" "kpvcrlib/crengine"
        chmod -R +w "kpvcrlib/crengine"
        # ????
        (
          cd thirdparty/kpvcrlib/
          ln -s ../../kpvcrlib/crengine
        )
      )

      ${
        concatMapStringsSep "\n" (name: ''
          copy-third-party "${name}" "${deps.${name}.src}"
        '') (builtins.attrNames deps)
      }

      # FIXME: generalize?
      # Not installed to the usual path :/
      echo ":: Adding thirdparty"

      echo "   → nanosvg"
      mkdir -p /build/source/base/thirdparty/nanosvg/build/nanosvg-prefix/src
      cp -rf \
        "${deps.nanosvg.src}" \
        /build/source/base/thirdparty/nanosvg/build/nanosvg-prefix/src/nanosvg

      # ¯\_(ツ)_/¯
      echo " :: Applying misc. fixups to third party..."
      (
      if [ -e "$(third-party-dir harfbuzz)/harfbuzz/src/update-unicode-tables.make" ]; then
        substituteInPlace "$(third-party-dir harfbuzz)/harfbuzz/src/update-unicode-tables.make" \
          --replace "/usr/bin/env -S make -f" "/usr/bin/make -f"
      fi

      # From NixOS's package
      substituteInPlace "$(third-party-dir openssl)/openssl/config" \
        --replace '/usr/bin/env' '${buildPackages.coreutils}/bin/env'


      # /usr/bin/env usage, but substitution happens too late if this is not +x'd
        substituteInPlace "$(third-party-dir glib)/glib/gobject/glib-mkenums.in" \
          --replace "/usr/bin/env @PYTHON@" "${python27}/bin/python2.7"
      )

      patchShebangs .

      # Even when the source is present, the ExternalProject_Add function tries
      # to download the third party component..
      for f in base/thirdparty/*/CMakeLists.txt ; do
        echo ":: Removing DOWNLOAD_COMMAND from $f"
        substituteInPlace "$f" \
          --replace "DOWNLOAD_COMMAND" "#DOWNLOAD_COMMAND" \
          --replace " URL" " #URL"
      done
    '';

    nativeBuildInputs = [
      git
      util-linux
      which

      luarocks

      ragel

      cmake
      autoconf
      automake
      libtool
      autoconf-archive
      pkg-config
      perl
      python27
    ];

    buildInputs = [
      gettext

      # For mupdf
      jbig2dec
      openjpeg
      zlib
    ];

    NIX_CFLAGS_COMPILE = [ "-I${openjpeg.dev}/include/${openjpeg.incDir}" ];

    VERBOSE = "1";
    makeFlags = [
      "VERBOSE=1"
    ];
    cmakeFlags = [
      "-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"
    ];

    # ¯\_(ツ)_/¯
    #configurePhase = ''
    #'';
    dontUseCmakeConfigure = true;

    # ¯\_(ツ)_/¯
    buildPhase = ''
      ./kodev build
    '';

    /* FIXME */
    src = builtins.fetchGit {
      url = ./koreader;
      submodules = true;
    };


  }
) { }
