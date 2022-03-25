{ pkgs ? import <nixpkgs> {} }:

pkgs.callPackage (
  { stdenv
  , buildPackages
  , fetchurl
  , fetchFromGitHub
  , fetchFromGitLab
  , writeShellScriptBin

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

  , luaPackages

  , ragel

  # thirdparty
  , luajit
  , libjpeg_turbo
  , djvulibre
  , zlib
  , libpng
  #, tesseract
  #, leptonica
  , zstd
  , freetype
  , harfbuzz
  , fribidi
  #, libunibreak
  , utf8proc

  # For mupdf
  , jbig2dec
  , openjpeg
  }:

  let
    luarocks = writeShellScriptBin "luarocks" ''
      echo "----"
      echo luarocks "$@"
      echo "----"
      exit 1
    '';
    inherit (luaPackages) luafilesystem;

    crengine = {
      src = fetchFromGitHub {
        owner = "koreader";
        repo = "crengine";
        rev = "b0fdab357637e9b3aa407e5dfa102adc3c303f68";
        hash = "sha256-5poGUwXkllgE+kYAtLFMLb9r3FOTpJ6OAQhHu7sp3o8=";
      };
    };

    libk2pdfopt = fetchFromGitHub {
      owner = "koreader";
      repo = "libk2pdfopt";
      # Sync with base/thirdparty/libk2pdfopt/CMakeLists.txt
      # XXX: somehow make this break on package updates
      rev = "24b7e6bc136667c98feaa1b519a99dd880b05ebe";
      hash = "sha256-hwyucSELK8xOh0s6qj85FVmbn7IHEb/g/48qiLqKElY=";
    };

    leptonica = {
      src = fetchFromGitHub {
        owner = "DanBloomberg";
        repo = "leptonica";
        # Sync with: base/thirdparty/leptonica/CMakeLists.txt
        rev = "1.74.1";
        sha256 = "sha256-SDXKam768xvZZvTbXe3sssvZyeLEEiY97Vrzx8hoc6g=";
      };
    };

    tesseract = {
      src = fetchFromGitHub {
        owner = "tesseract-ocr";
        repo = "tesseract";
        # Sync with base/thirdparty/tesseract/CMakeLists.txt
        rev = "60176fc5ae5e7f6bdef60c926a4b5ea03de2bfa7";
        hash = "sha256-FQvlrJ+Uy7+wtUxBuS5NdoToUwNRhYw2ju8Ya8MLyQw=";
      };
    };

    #harfbuzz = {
    #  src = fetchFromGitHub {
    #    owner = "harfbuzz";
    #    repo = "harfbuzz";
    #    # Sync with base/thirdparty/harfbuzz/CMakeLists.txt
    #    rev = "3.0.0";
    #    hash = "sha256-yRRr4RcnbwoZ1Hn3+zbbocKFyBSLYx/exaAHNGsPINA=";
    #  };
    #};

    libunibreak = {
      src = fetchFromGitHub {
        owner = "adah1972";
        repo = "libunibreak";
        rev = "refs/tags/libunibreak_4_3";
        hash = "sha256-nd4i0JYVRPIpx2lCBjUEHcBEcpFno/ZtczoyH3SP46U=";
      };
    };

    nanosvg = {
      src = fetchFromGitHub {
        owner = "memononen";
        repo = "nanosvg";
        rev = "3cdd4a9d788695699799b37d492e45e2c3625790";
        hash = "sha256-8/WT9t5AJCcat3ZYb9VJZwz0Uisb8TqNV2sU2YV6vBE=";
      };
    };

    minizip = {
      src = fetchFromGitHub {
        owner = "nmoinvaz";
        repo = "minizip";
        rev = "0b46a2b4ca317b80bc53594688883f7188ac4d08";
        hash = "sha256-P/3MMMGYDqD9NmkYvw/thKpUNa3wNOSlBBjANHSonAg=";
      };
    };

    mupdf = {
      src = fetchFromGitHub {
        owner = "ArtifexSoftware";
        repo = "mupdf";
        rev = "refs/tags/1.13.0";
        hash = "sha256-76kIZy1FFQ8B9Hf0MSJm8WhR8mOHkWZgX3zEjULqPtY=";
      };
    };

    luasocket = {
      src = fetchFromGitHub {
        owner = "diegonehab";
        repo = "luasocket";
        rev = "5b18e475f38fcf28429b1cc4b17baee3b9793a62";
        hash = "sha256-yu+AV0u8qrrvlNRefizhUJZsqgR9L64urxu0UAR+cAA=";
      };
    };

    openssl = {
      src = fetchFromGitHub {
        owner = "openssl";
        repo = "openssl";
        rev = "OpenSSL_1_1_1l";
        hash = "sha256-FN0OVoE92tpDpkHx8Oh9XuzovZ8IP/lxt7YFREoWLy4=";
      };
    };

    luasec = {
      src = fetchFromGitHub {
        owner = "brunoos";
        repo = "luasec";
        rev = "refs/tags/v1.0.2";
        hash = "sha256-ikpym/eLMfro8egTVJBLxq2X4/iXr7JF+E++wbE4HZI=";
      };
    };

    lodepng = {
      src = fetchFromGitHub {
        owner = "lvandeve";
        repo = "lodepng";
        rev = "7fdcc96a5e5864eee72911c3ca79b1d9f0d12292";
        hash = "sha256-IZxQyjr74n3ZWydcpsG51eSBP834NtJBrrk/UZJFcvg=";
      };
    };

    giflib = {
      src = fetchFromGitLab {
        owner = "koreader";
        repo = "giflib";
        rev = "5.1.4";
        hash = "sha256-znbY4tliXHXVLBd8sTKrbglOdCUb7xhcCQsDDWcQfhw=";
      };
    };

    turbo = {
      src = fetchFromGitHub {
        owner = "kernelsauce";
        repo = "turbo";
        rev = "refs/tags/v2.1.3";
        hash = "sha256-vBRkFdc5a0FIt15HBz3TnqMZ+GGsqjEefnfJEpuVTBs=";
      };
    };

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
          set -x
          cp -rf \
            "$src" \
            $dir/$name
          chmod -R +w $dir
          )
        else
          case "$src" in
            *.tar.gz|*.tar.xz)
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
        PS4=" $ "
        set -x
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

      copy-third-party "luajit"        "${luajit.src}"
      copy-third-party "libjpeg-turbo" "${libjpeg_turbo.src}"
      copy-third-party "djvulibre"     "${djvulibre.src}"
      copy-third-party "zlib"          "${zlib.src}"
      copy-third-party "libpng"        "${libpng.src}"
      copy-third-party "tesseract"     "${tesseract.src}"
      copy-third-party "leptonica"     "${leptonica.src}"
      copy-third-party "libk2pdfopt"   "${libk2pdfopt}"
      copy-third-party "zstd"          "${zstd.src}"
      copy-third-party "freetype2"     "${freetype.src}"
      copy-third-party "harfbuzz"      "${harfbuzz.src}"
      copy-third-party "fribidi"       "${fribidi.src}"
      copy-third-party "libunibreak"   "${libunibreak.src}"
      copy-third-party "utf8proc"      "${utf8proc.src}"
      copy-third-party "minizip"       "${minizip.src}"
      copy-third-party "mupdf"         "${mupdf.src}"
      copy-third-party "luasocket"     "${luasocket.src}"
      copy-third-party "openssl"       "${openssl.src}"
      copy-third-party "luasec"        "${luasec.src}"
      copy-third-party "lodepng"       "${lodepng.src}"
      copy-third-party "giflib"        "${giflib.src}"
      copy-third-party "turbo"         "${turbo.src}"

      # FIXME: generalize?
      # Not installed to the usual path :/
      echo ":: Adding thirdparty"
      mkdir -p /build/source/base/thirdparty/nanosvg/build/nanosvg-prefix/src
      cp -rf \
        "${nanosvg.src}" \
        /build/source/base/thirdparty/nanosvg/build/nanosvg-prefix/src/nanosvg

      # ¯\_(ツ)_/¯
      echo " :: Applying misc. fixups to third party..."
      (
      PS4=" $ "
      set -x

      if [ -e "$(third-party-dir harfbuzz)/harfbuzz/src/update-unicode-tables.make" ]; then
        substituteInPlace "$(third-party-dir harfbuzz)/harfbuzz/src/update-unicode-tables.make" \
          --replace "/usr/bin/env -S make -f" "/usr/bin/make -f"
      fi

      # From NixOS's package
      substituteInPlace "$(third-party-dir openssl)/openssl/config" \
        --replace '/usr/bin/env' '${buildPackages.coreutils}/bin/env'
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
    ];

    buildInputs = [
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
