let
  rev = "e3652e0735fbec227f342712f180f4f21f0594f2";
  sha256 = "sha256:1h38yml73lxirxx6ynzmk3h4fw6wlgz8z8105cj733s8cvjyp03h";
in
import (
  builtins.fetchTarball {
    inherit sha256;
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  }
)
