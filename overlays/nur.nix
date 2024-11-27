{ flake, ... }:
let
  inherit (flake.inputs) nur;
in
final: prev: {
  nur = import nur {
    nurpkgs = prev;
    pkgs = prev;
  };
}
