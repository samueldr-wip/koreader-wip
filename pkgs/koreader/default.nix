{ stdenv
, lib
, buildPackages
, fetchurl
, fetchFromGitHub
, fetchFromGitLab
, writeShellScriptBin
, makeWrapper

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
, python3
, chrpath # Used to fix RPATH refs by their build system

, ragel

# Runtime deps

, gtk3-x11
, SDL2
, glib

# Third party deps
, freetype
, luaPackages

# Misc dependencies

, gettext
, zlib

# For mupdf
, jbig2dec
, openjpeg

# Fonts
, noto-fonts
, nerdfonts

, isDebug ? false

# Enables a hack that returns a memoized thirdparty libs build.
# Used to speed-up hacking on the project
, buildMemoizedLibs ? false
, memoizedLibBuild ? null
}:

let
  inherit (lib)
    concatMapStringsSep
  ;

  # fakeroot is used by dpkg-deb only.
  fakeroot-passthrough = writeShellScriptBin "fakeroot" ''
    exec "''${@}"
  '';
  dpkg-noop = writeShellScriptBin "dpkg-deb" ''
    echo "NO-OP: $ dpkg-deb " "''${@}"
  '';

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

  # luarocks to include in the build...
  # ... but not really necessarily pre-built...
  rocks = {
    luajson = {
      src = fetchFromGitHub {
        owner = "harningt";
        repo = "luajson";
        rev = "refs/tags/1.3.4";
        hash = "sha256-JaJsjN5Gp+8qswfzl5XbHRQMfaCAJpWDWj9DYWJ0gEI=";
      };
    };
    inherit (luaPackages) lpeg;
  };

  font-droid = nerdfonts.override { fonts = [ "DroidSansMono" ]; };

  # See Makefile; KODEDUG_SUFFIX:=-debug
  debugVars =
    if isDebug then {
      KODEBUG_SUFFIX = "-debug";
      KODEBUG = "1";
      KODEBUG_NO_DEFAULT = "1";
    }
    else {
      KODEBUG_SUFFIX = "";
    }
  ;
in
stdenv.mkDerivation (debugVars // {
  pname = "koreader";
  # NOTE: `version` must be parseable by frontend/version.lua#Version:getNormalizedVersion
  #       we are saving it to `git-rev` since we're not allowing `git` to identify the version in the build.
  version = "v2023.03-wip";

  # TODO: use non-submodules fetchFromGitHub, but with a list pre-composed not unlike deps.nix?
  # Might make it easier to replace just one repo for development purposes.
  # XXX: Currently overriding `src`; not setting it here to ensure I don't trip-up while hacking on stuff...
  ## src = fetchFromGitHub {
  ##   owner = "koreader";
  ##   repo = "koreader";
  ##   rev = "";
  ##   hash = "";
  ##   fetchSubmodules = true;
  ## };

  postPatch = ''
    third-party-dir() {
      local name="$1"; shift
      echo "$NIX_BUILD_TOP/source/base/thirdparty/$name/build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/$name-prefix/src"
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

    # Copying third party dirs
    ${
      concatMapStringsSep "\n" (name: ''
        copy-third-party "${name}" "${deps.${name}.src}"
      '') (builtins.attrNames deps)
    }

    # Not installed to the usual path :/
    echo ":: Adding thirdparty"

    echo "   → nanosvg"
    mkdir -p $NIX_BUILD_TOP/source/base/thirdparty/nanosvg/build/nanosvg-prefix/src
    cp -rf \
      "${deps.nanosvg.src}" \
      $NIX_BUILD_TOP/source/base/thirdparty/nanosvg/build/nanosvg-prefix/src/nanosvg

    # Handled by download_project/add_subdirectory :/

    echo "   → sdcv"
    mkdir -p $NIX_BUILD_TOP/source/base/thirdparty/sdcv/build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/
    cp -rf \
      "${deps.sdcv.src}" \
      $NIX_BUILD_TOP/source/base/thirdparty/sdcv/build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/sdcv-download
    chmod -R +w $NIX_BUILD_TOP/source/base/thirdparty/sdcv/build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/sdcv-download
    cp -rf \
      "${deps.sdcv.src}" \
      $NIX_BUILD_TOP/source/base/thirdparty/sdcv/build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/sdcv-src
    chmod -R +w $NIX_BUILD_TOP/source/base/thirdparty/sdcv/build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/sdcv-src

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
        --replace "/usr/bin/env @PYTHON@" "${python3}/bin/python"
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

    echo ":: Removing plugins"
    rm -rf plugins/*
  '';

  nativeBuildInputs = [
    git
    util-linux
    which
    makeWrapper

    dpkg-noop
    fakeroot-passthrough

    cmake
    autoconf
    automake
    libtool
    autoconf-archive
    pkg-config
    perl
    python3
    #chrpath # XXX bug: no rpath at all; fix: add $out libs folder to rpath
    ragel
    luarocks
  ];

  buildInputs = [
    gettext

    # For mupdf
    jbig2dec
    openjpeg
    zlib
  ];

  # XXX for mupdf
  # FIXME: add those flags only for the mupdf build (by patching its makefile I guess)
  /* XXX */    NIX_CFLAGS_COMPILE = [ "-I${openjpeg.dev}/include/${openjpeg.incDir}" ];
  /* XXX */    NIX_LDFLAGS = [
  /* XXX */      "-lopenjp2"
  /* XXX */      "-ljbig2dec"
  /* XXX */    ];

  # cmake is not used for the project itself, but to manage parts of the build.
  dontUseCmakeConfigure = true;

  # ¯\_(ツ)_/¯
  # Calling `make` without a TARGET is equivalent to an "unqualified" emulator build
  # By "unqualified" I mean without enabling UBUNTUTOUCH/DEBIAN/MACOS or other targets.
  # https://github.com/koreader/koreader-base/blob/90f8adcc0b3e189988731fde2b7e6e0f281bac2b/Makefile.defs#L175
  # https://github.com/koreader/koreader/blob/d53ee056cc562eaf08cb0ae050be9d6c1c8b2483/kodev#L316-L324
  # Similarly, calling `./kodev build` is mostly equivalent to calling `make` unqualified.
  buildPhase = ''
    ${if memoizedLibBuild == null then ''
    (
    cd base

    echo ":: Building third-party libraries"

    # The shorted `make` invocation to build all thirdparty libs
    make TARGET=debian \
      build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/libs \
      build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/libs/libcrengine.so \
      build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/libs/libczmq.so.1 \
      build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/libs/libgif.so.7 \
      build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/libs/liblodepng.so \
      build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/libs/libluajit.so \
      build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/libs/libsqlite3.so \
      build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/libs/libzmq.so.4 \
      build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/jit \
      build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/luajit \
      build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/sdcv \
      build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/tar \
      libs
    )
    ${if buildMemoizedLibs then ''
      mkdir -p $out/base/build/

      echo ":: Copying thirdparty"
      cp -prf \
        base/thirdparty \
        $out/base/thirdparty

      echo ":: Copying build"
      cp -prf \
        base/build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX \
        $out/base/build/

      echo "============================================"
      echo "| NOTE: Only the libs targets were built!! |"
      echo "============================================"

      exit 0
    '' else ""
      # Ugh, we'll have to memoize all of this too?
      # echo "thirdparty/$name/build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/$name-prefix/src"
      }
    '' else ''
      echo "==============================="
      echo "| NOTE: This build is impure! |"
      echo "==============================="

      mkdir -p base/build/

      # Obliterate anything in our way
      chmod -R +w base
      rm -rf base/build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX
      rm -rf base/thirdparty

      # Copy the memoized lib build
      cp -prf ${memoizedLibBuild}/base/build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX base/build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX
      cp -prf ${memoizedLibBuild}/base/thirdparty base/thirdparty

      # Ensures this is writable
      chmod -R +w base/

      # Ensures timestamp is recent enough that it won't be rebuilt
      find base/build -exec 'touch' '{}' ';'
      find base/thirdparty/*/build/${stdenv.hostPlatform.config}$KODEBUG_SUFFIX/*-prefix/src/*-build/ \
        -exec 'touch' '{}' ';'

    ''}

    echo ":: Building"
    # Can't parallelize as targets won't build
    make -j 1

    echo ":: Updating target"
    # DO_STRIP is buggy, and anyway handled by Nixpkgs
    make update TARGET=debian DO_STRIP=0

    echo ":: Applying fixups"
    (
    cd "koreader-debian-${stdenv.hostPlatform.config}$KODEBUG_SUFFIX"/debian/usr/

    substituteInPlace lib/koreader/reader.lua \
      --replace "#!/usr/lib/koreader/luajit" "#!$out/lib/koreader/luajit"
    )
  '';

  installPhase = ''
    echo ":: Copying koreader..."
    (
    PS4=" $ "
    set -x

    mkdir -p $out/

    cp -pr -t $out \
      "koreader-debian-${stdenv.hostPlatform.config}$KODEBUG_SUFFIX"/debian/usr/*
    rm -rf $out/debian
    )

    echo ":: Copying required lua rocks..."
    (
    PS4=" $ "
    set -x
    mkdir -vp $out/lib/koreader/rocks/share/lua/5.1/
    cp -rvt $out/lib/koreader/rocks/share/lua/5.1/ -prf ${rocks.luajson.src}/lua/*

    mkdir -vp $out/lib/koreader/rocks
    cp -rvt $out/lib/koreader/rocks/ ${rocks.lpeg}/{lib,share}
    )

    echo ":: Fixing up fonts..."
    (
    PS4=" $ "
    set -x
    find $out/lib/koreader/fonts -xtype l -delete

    for i in ${noto-fonts}/share/fonts/truetype/noto/*; do
      ln -s "$i" $out/lib/koreader/fonts/noto/
    done
    ln -s "${font-droid}/share/fonts/opentype/NerdFonts/Droid Sans Mono Nerd Font Complete Mono.otf" $out/lib/koreader/fonts/droid/DroidSansMono.ttf

    )

    echo ":: Last fixups"

    # Somehow koreader is not using its own build for these libraries:
    wrapProgram $out/bin/koreader \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ gtk3-x11 SDL2 glib ]}:$out/lib/koreader/libs/"

    # koreader needs a version in there, not an empty file...
    echo $version > $out/lib/koreader/git-rev
  '';

  # The memoized lib keeps refs to /build/, and it doesn't matter to us since
  # it's used only for hacking purposes
  #noAuditTmpdir = buildMemoizedLibs;
  noAuditTmpdir = true; # XXX
})
