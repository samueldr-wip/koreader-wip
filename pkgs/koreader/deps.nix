{ fetchFromGitHub, fetchFromGitLab, fetchurl }:

{
  curl = {
    src = fetchFromGitHub {
      owner = "curl";
      repo = "curl";
      rev = "tags/curl-7_80_0";
      hash = "sha256-kzozc0Io+1f4UMivSV2IhzJDQXmad4wNhXN/Y2Lsg3Q=";
    };
  };
  
  czmq = {
    src = fetchFromGitHub {
      owner = "zeromq";
      repo = "czmq";
      rev = "2a0ddbc4b2dde623220d7f4980ddd60e910cfa78";
      hash = "sha256-p4Cl2PLVgRQ0S4qr3VClJXjvAd2LUBU9oRUvOCfVnyw=";
    };
  };
  
  djvulibre = {
    src = fetchFromGitLab {
      owner = "koreader";
      repo = "djvulibre";
      rev = "6a1e5ba1c9ef81c205a4b270c3f121a1e106f4fc";
      hash = "sha256-OWSbxdr93FH3ed0D+NSFWIah7VDTcL3LIGOciY+f4dk=";
    };
  };
  
  dropbear = {
    src = fetchurl {
      url = "http://deb.debian.org/debian/pool/main/d/dropbear/dropbear_2018.76.orig.tar.bz2";
      hash = "sha256-8vuRZ+yoz5NFal/B1Pr3CZAqOrcN1E41LzrLw//a6mU=";
    };
  };
  
  fbink = {
    src = fetchFromGitHub {
      owner = "NiLuJe";
      repo = "FBInk";
      rev = "tags/v1.25.0";
      hash = "sha256-YehNy+2ALcGpbys6hoTT2BmAWjOQqTEpiCHm6GXDekE=";
    };
  };
  
  freetype2 = {
    src = fetchFromGitLab {
      owner = "koreader";
      repo = "freetype2";
      rev = "VER-2-13-0";
      hash = "sha256-dOm8VKYdclTLLkqWMLv7DQI0Qyjit7S4SOCszKEkG3o=";
    };
  };
  
  fribidi = {
    src = fetchFromGitHub {
      owner = "fribidi";
      repo = "fribidi";
      rev = "tags/v1.0.12";
      hash = "sha256-L4m/F9rs8fiv9rSf8oy7P6cthhupc6R/lCv30PLiQ4M=";
    };
  };
  
  gettext = {
    src = fetchurl {
      url = "http://ftpmirror.gnu.org/gettext/gettext-0.21.tar.gz";
      hash = "sha256-x30NoxAq7JwH9DZx5gYR6/+JqZbvFZSXzo5Z0HV4axI=";
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
  
  glib = {
    src = fetchFromGitHub {
      owner = "GNOME";
      repo = "glib";
      rev = "2.58.3";
      hash = "sha256-KmJXCJ6h2QhPyK1axk+Y9+yJzO0wnCczcogopxGShJc=";
    };
  };
  
  harfbuzz = {
    src = fetchFromGitHub {
      owner = "harfbuzz";
      repo = "harfbuzz";
      rev = "5.3.1";
      hash = "sha256-vTx86b8WUD34gMdbdXRTDuwy9+Vobtql2DI0uUmQhMM=";
    };
  };
  
  kobo-usbms = {
    src = fetchFromGitHub {
      owner = "koreader";
      repo = "KoboUSBMS";
      rev = "tags/v1.3.8";
      hash = "sha256-yflTU8OR2Fp0Ew04VqpUzP4MpDURap9oW7AmerCo4BI=";
    };
  };
  
  
  leptonica = {
    src = fetchFromGitHub {
      owner = "DanBloomberg";
      repo = "leptonica";
      rev = "1.74.1";
      hash = "sha256-SDXKam768xvZZvTbXe3sssvZyeLEEiY97Vrzx8hoc6g=";
    };
  };
  
  libffi = {
    src = fetchurl {
      url = "https://github.com/libffi/libffi/releases/download/v3.4.4/libffi-3.4.4.tar.gz";
      hash = "sha256-1mxWrSWags8qnfxAizK/XaUjcVALhHRff7i2RXEt9nY=";
    };
  };
  
  libiconv = {
    src = fetchurl {
      url = "http://ftpmirror.gnu.org/libiconv/libiconv-1.15.tar.gz";
      hash = "sha256-zPU2YgpFRY0muoOIepg7loJwAekqE4R7ReSSXMiRMXg=";
    };
  };
  
  libjpeg-turbo = {
    src = fetchFromGitHub {
      owner = "libjpeg-turbo";
      repo = "libjpeg-turbo";
      rev = "2.1.5.1";
      hash = "sha256-96SBBZp+/4WkXLvHKSPItNi5WuzdVccI/ZcbJOFjYYk=";
    };
  };
  
  libk2pdfopt = {
    src = fetchFromGitHub {
      owner = "koreader";
      repo = "libk2pdfopt";
      rev = "6f479e7d1df48df491ff2398388c562b7cd5bf30";
      hash = "sha256-ODYOmOg9GK+8fg2R6cA9al6g4h5MuUMzX6WfKfC8Fzo=";
    };
  };
  
  libpng = {
    src = fetchFromGitHub {
      owner = "glennrp";
      repo = "libpng";
      rev = "v1.6.39";
      hash = "sha256-RBU+7e77CaUqEiVn/YZRgn4dt4jDZOTUVSZYvnvKlvU=";
    };
  };
  
  libunibreak = {
    src = fetchFromGitHub {
      owner = "adah1972";
      repo = "libunibreak";
      rev = "tags/libunibreak_5_1";
      hash = "sha256-hjgT5DCQ6KFXKlxk9LLzxGHz6B71X/3Ot7ipK3KY85A=";
    };
  };
  
  libwebp = {
    src = fetchFromGitHub {
      owner = "webmproject";
      repo = "libwebp";
      rev = "v1.2.4";
      hash = "sha256-XX6qOWlIl8TqOQMiGpmmDVKwQnM1taG6lrqq1ZFVk5s=";
    };
  };
  
  libzmq = {
    src = fetchFromGitHub {
      owner = "zeromq";
      repo = "libzmq";
      rev = "883e95b22e0bffffa72312ea1fec76199afbe458";
      hash = "sha256-R76EREtHsqcoKxKrgT8gfEf9pIWdLTBXvF9cDvjEf3E=";
    };
  };
  
  lj-wpaclient = {
    src = fetchFromGitHub {
      owner = "koreader";
      repo = "lj-wpaclient";
      rev = "2f93beb3071e6ebb57c783bd5b92f83aa5ebb757";
      hash = "sha256-ilJviGZTvL2i1TN5lHQ4eA9pFiM7NlXD+v9ofv520b8=";
    };
  };
  
  lodepng = {
    src = fetchFromGitHub {
      owner = "lvandeve";
      repo = "lodepng";
      rev = "997936fd2b45842031e4180d73d7880e381cf33f";
      hash = "sha256-F0ABp393WWcsWJaGIBsQkUXUGi5BCUpPzb2m0moi8A8=";
    };
  };
  
  lpeg = {
    src = fetchurl {
      url = "http://distcache.FreeBSD.org/ports-distfiles/lpeg-1.0.2.tar.gz";
      hash = "sha256-SNZldgUbbHg4j6rQm3BJMJMmRYj80PJY3aqxzdShX/4=";
    };
  };
  
  lua-Spore = {
    src = fetchFromGitLab {
      domain = "framagit.org";
      owner = "fperrad";
      repo = "lua-Spore";
      rev = "tags/0.3.3";
      hash = "sha256-wb7ykJsndoq0DazHpfXieUcBBptowYqD/eTTN/EK/6g=";
    };
  };
  
  lua-htmlparser = {
    src = fetchFromGitHub {
      owner = "msva";
      repo = "lua-htmlparser";
      rev = "2ce09f82a4244c243d9fd0abe6c38e20411912f7";
      hash = "sha256-5Woku6jkB1pO45l58j70gFZGolXXzjjhgax/zecaTvY=";
    };
  };
  
  lua-rapidjson = {
    src = fetchFromGitHub {
      owner = "xpol";
      repo = "lua-rapidjson";
      rev = "242b40c8eaceb0cc43bcab88309736461cac1234";
      hash = "sha256-y/czEVPtCt4uN1n49Qi7BrgZmkG+SDXlM5D2GvvO2qg=";
    };
  };
  
  luajit = {
    src = fetchFromGitHub {
      owner = "LuaJIT";
      repo = "LuaJIT";
      rev = "d0e88930ddde28ff662503f9f20facf34f7265aa";
      hash = "sha256-ELAr/POHzXXy1LkdMAM5KMDlYVdN5F6nGAEMHpGY2PU=";
    };
  };
  
  luasec = {
    src = fetchFromGitHub {
      owner = "brunoos";
      repo = "luasec";
      rev = "tags/v1.3.1";
      hash = "sha256-3iYRNQoVk5HFjDSqRRmg1taSqeT2cHFil36vxjrEofo=";
    };
  };
  
  luasocket = {
    src = fetchFromGitHub {
      owner = "lunarmodules";
      repo = "luasocket";
      rev = "8c2ff7217e2a205eb107a6f48b04ff1b2b3090a1";
      hash = "sha256-Y35QYNLznQmErr6rIjxLzw0/6Y7y8TbzD4yaEdgEljA=";
    };
  };
  
  lunasvg = {
    src = fetchFromGitHub {
      owner = "sammycage";
      repo = "lunasvg";
      rev = "585d61eef24510bc0b7fe3d9e768d0675d4b5a6f";
      hash = "sha256-aV/TzTqbVwI1OPBnbxRuHyB+xprn7E0dOWWq50OnD9Q=";
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
      rev = "tags/1.13.0";
      hash = "sha256-76kIZy1FFQ8B9Hf0MSJm8WhR8mOHkWZgX3zEjULqPtY=";
    };
  };
  
  nanosvg = {
    src = fetchFromGitHub {
      owner = "memononen";
      repo = "nanosvg";
      rev = "9da543e8329fdd81b64eb48742d8ccb09377aed1";
      hash = "sha256-VOiN6583DtzGYPRkl19VG2QvSzl4T9HaynBuNcvZf94=";
    };
  };
  
  openssh = {
    src = fetchFromGitHub {
      owner = "openssh";
      repo = "openssh-portable";
      rev = "V_8_6_P1";
      hash = "sha256-yjIpSbe5pt9sEV2MZYGztxejg/aBFfKO8ieRvoLN2KA=";
    };
  };
  
  openssl = {
    src = fetchFromGitHub {
      owner = "openssl";
      repo = "openssl";
      rev = "OpenSSL_1_1_1t";
      hash = "sha256-gI2+Vm67j1+xLvzBb+DF0YFTOHW7myotRsXRzluzSLY=";
    };
  };
  
  popen-noshell = {
    src = fetchFromGitHub {
      owner = "famzah";
      repo = "popen-noshell";
      rev = "e715396a4951ee91c40a98d2824a130f158268bb";
      hash = "sha256-JeBZMsg6ZUGSnyZ4eds4w63gM/L73EsAnLaHOPpL6iM=";
    };
  };
  
  sdcv = {
    src = fetchFromGitHub {
      owner = "Dushistov";
      repo = "sdcv";
      rev = "6e36e7730caf07b6cd0bfa265cdf9b5e31e7acad";
      hash = "sha256-pPaT9tB39dd+VyE21KSjMpON99KjOxQ8Hi8+ZgFsuUY=";
    };
  };
  
  
  sqlite = {
    src = fetchurl {
      url = "https://www.sqlite.org/2023/sqlite-autoconf-3410000.tar.gz";
      hash = "sha256-Sfd6xT/Zql1zlfJJnLgWQQ5WIZhKEhuFjMygUxCwXHA=";
    };
  };
  
  tar = {
    src = fetchurl {
      url = "http://ftpmirror.gnu.org/tar/tar-1.34.tar.gz";
      hash = "sha256-A9kIz1doz+a3rViMkhxu0hrKv7K3m3iNEzBFNQdkeu0=";
    };
  };
  
  tesseract = {
    src = fetchFromGitHub {
      owner = "tesseract-ocr";
      repo = "tesseract";
      rev = "60176fc5ae5e7f6bdef60c926a4b5ea03de2bfa7";
      hash = "sha256-FQvlrJ+Uy7+wtUxBuS5NdoToUwNRhYw2ju8Ya8MLyQw=";
    };
  };
  
  turbo = {
    src = fetchFromGitHub {
      owner = "kernelsauce";
      repo = "turbo";
      rev = "tags/v2.1.3";
      hash = "sha256-vBRkFdc5a0FIt15HBz3TnqMZ+GGsqjEefnfJEpuVTBs=";
    };
  };
  
  utf8proc = {
    src = fetchFromGitHub {
      owner = "JuliaStrings";
      repo = "utf8proc";
      rev = "v2.8.0";
      hash = "sha256-/lSD78kj133rpcSAOh8T8XFW/Z0c3JKkGQM5Z6DcMtU=";
    };
  };
  
  zlib = {
    src = fetchurl {
      url = "http://gentoo.osuosl.org/distfiles/zlib-1.2.13.tar.xz";
      hash = "sha256-0Uw44xOvw1qah2Da3yYEL1HqD10VSwYwox2gVAEH+5g=";
    };
  };
  
  zstd = {
    src = fetchFromGitHub {
      owner = "facebook";
      repo = "zstd";
      rev = "tags/v1.5.4";
      hash = "sha256-2blY4hY4eEcxY8K9bIhYPbfb//rt/+J2TmvxABPG78A=";
    };
  };
  
  zsync2 = {
    src = fetchFromGitHub {
      owner = "NiLuJe";
      repo = "zsync2";
      rev = "e618d18f6a7cbf350cededa17ddfe8f76bdf0b5c";
      hash = "sha256-iJt3wO+zqQ6DCZF+Rq8o6iPULzXHNwgF4YnwED06GeI=";
    };
  };
}
