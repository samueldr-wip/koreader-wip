let
  rev = "ce8cbe3c01fd8ee2de526ccd84bbf9b82397a510";
  sha256 = "19xfad7pxsp6nkrkjhn36w77w92m60ysq7njn711slw74yj6ibxv";
in
import (
  builtins.fetchTarball {
    inherit sha256;
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  }
)
