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
  home.username = me.username;
  home.homeDirectory = "/home/${me.username}";
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = me.username;

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
