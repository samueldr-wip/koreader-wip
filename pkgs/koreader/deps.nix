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
      rev = "tags/release.3.5.28";
      hash = "sha256-J/FuNKAgBtpQHPywNVdQ1d44LRMUQJw3pK8+Ml2Ai+0=";
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
      rev = "b7a81463502c8a445e85edd8e1903dca0ede7f5f";
      hash = "sha256-TvhW0b2i5ZFLrTnwGmMa5M1wsXi5inrssxM7Z5BT15A=";
    };
  };
  
  freetype2 = {
    src = fetchFromGitLab {
      owner = "koreader";
      repo = "freetype2";
      rev = "VER-2-11-1";
      hash = "sha256-I4j7vn+xQLpwWOG6wWMszyg0sMRCmcLpJLfQi1QJKfE=";
    };
  };
  
  fribidi = {
    src = fetchFromGitHub {
      owner = "fribidi";
      repo = "fribidi";
      rev = "tags/v1.0.11";
      hash = "sha256-2y4oN02X88JG2h7366owwcYVkMJJFntgMDcNNmYYTGg=";
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
      rev = "3.0.0";
      hash = "sha256-yRRr4RcnbwoZ1Hn3+zbbocKFyBSLYx/exaAHNGsPINA=";
    };
  };
  
  kobo-usbms = {
    src = fetchFromGitHub {
      owner = "koreader";
      repo = "KoboUSBMS";
      rev = "tags/v1.3.0";
      hash = "sha256-Em5u64DUCLtX+sGkqPI5EneQCV5Jje3ptFgFdSjGeFY=";
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
      url = "https://sourceware.org/pub/libffi/libffi-3.3.tar.gz";
      hash = "sha256-cvunkicD3fp6Ao1ROsFahcjVTI1n9V+lpIAohdxlIFY=";
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
      rev = "2.1.2";
      hash = "sha256-mlHueKAU/uNUdV9s4jWKAE+XVJdpEFhw2hxGvqRwAGc=";
    };
  };
  
  libk2pdfopt = {
    src = fetchFromGitHub {
      owner = "koreader";
      repo = "libk2pdfopt";
      rev = "24b7e6bc136667c98feaa1b519a99dd880b05ebe";
      hash = "sha256-hwyucSELK8xOh0s6qj85FVmbn7IHEb/g/48qiLqKElY=";
    };
  };
  
  libpng = {
    src = fetchFromGitHub {
      owner = "glennrp";
      repo = "libpng";
      rev = "v1.6.37";
      hash = "sha256-O/NsIIhjvJpp1Nl+Pj1GLJkR+nBqu+ymY5vcy/IU0GE=";
    };
  };
  
  libunibreak = {
    src = fetchFromGitHub {
      owner = "adah1972";
      repo = "libunibreak";
      rev = "tags/libunibreak_4_3";
      hash = "sha256-nd4i0JYVRPIpx2lCBjUEHcBEcpFno/ZtczoyH3SP46U=";
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
      rev = "4f95110298b89d80e762215331159657ae36b4ef";
      hash = "sha256-hAd1Bqyg7S7ms50JO4m5RKzW41UHSBiYX/NJ6V4x9iY=";
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
      rev = "4f6437ebd123c3e552a595fc818fdd952888fff2";
      hash = "sha256-FfAwUlH1/LjNIGNYP8TaToqjgfcY0knoXSRKYMDuggQ=";
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
      rev = "c4fe76d50cda24f3529604448f80ff14754599dd";
      hash = "sha256-MMQbqqT23wpMM8z9J5lReAGgWfZeUqnQBqJuWRHhqJo=";
    };
  };
  
  luasec = {
    src = fetchFromGitHub {
      owner = "brunoos";
      repo = "luasec";
      rev = "tags/v1.0.2";
      hash = "sha256-ikpym/eLMfro8egTVJBLxq2X4/iXr7JF+E++wbE4HZI=";
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
      rev = "3cdd4a9d788695699799b37d492e45e2c3625790";
      hash = "sha256-8/WT9t5AJCcat3ZYb9VJZwz0Uisb8TqNV2sU2YV6vBE=";
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
      rev = "OpenSSL_1_1_1l";
      hash = "sha256-FN0OVoE92tpDpkHx8Oh9XuzovZ8IP/lxt7YFREoWLy4=";
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
      rev = "d054adb37c635ececabc31b147c968a480d1891a";
      hash = "sha256-mJ9LrQ/l0SRmueg+IfGnS0NcNheGdOZ2Gl7KMFiK6is=";
    };
  };
  
  
  sqlite = {
    src = fetchurl {
      url = "https://www.sqlite.org/2021/sqlite-autoconf-3360000.tar.gz";
      hash = "sha256-vZDD65a+6ZYga4O+cGXJzhmu84w/T7Uwc62g0LabvOM=";
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
      rev = "v2.6.1";
      hash = "sha256-h6MVgyNFM4t6Ay0m9gAKIE1HF9qlW9Xl0nr+maMyDP8=";
    };
  };
  
  zlib = {
    src = fetchurl {
      url = "http://gentoo.osuosl.org/distfiles/zlib-1.2.11.tar.gz";
      hash = "sha256-w+Xp/dUATctUL+2l7k8P8HRGKLr47S3V1m+MoRl8saE=";
    };
  };
  
  zstd = {
    src = fetchFromGitHub {
      owner = "facebook";
      repo = "zstd";
      rev = "tags/v1.5.0";
      hash = "sha256-R+Y10gd3GE17AJ5zIXGI4tuOdyCikdZXwbkMllAHjEU=";
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
