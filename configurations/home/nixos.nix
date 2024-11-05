# My Ubuntu VM (Parallels)
{ flake, ... }:
let
  inherit (flake.inputs) self;
  inherit (flake.config) me;
in
{
  imports = [
    self.homeModules.default
    self.homeModules.linux-only
  ];
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
}
