# Configuration common to all Linux systems
{ flake, ... }:

let
  inherit (flake) config inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.common
    # inputs.ragenix.nixosModules.default # Used in github-runner.nix & hedgedoc.nix
    ./linux/current-location.nix
    ./linux/self-ide.nix
  ];
}
