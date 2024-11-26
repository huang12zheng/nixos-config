# My Ubuntu VM (Parallels)
{ flake, ... }:
let
  inherit (flake.inputs) self;
  inherit (flake.config) me;
in
{
  home.username = me.username;
  home.homeDirectory = "/home/${me.username}";

  imports = [
    self.homeModules.default
    self.homeModules.linux-only
  ];

}
