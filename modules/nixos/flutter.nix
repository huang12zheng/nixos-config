{ flake, config, pkgs, lib, system, ... }:
let
  inherit (flake.config.me) username;
in
{
  programs = {
    adb.enable = true;
  };

  users.users."${username}" = {
    extraGroups = [
      "adbusers"
    ];
  };

  # system.userActivationScripts = {
  #   stdio = {
  #     text = ''
  #       rm -f ~/Android/Sdk/platform-tools/adb
  #       ln -s /run/current-system/sw/bin/adb ~/Android/Sdk/platform-tools/adb
  #     '';
  #     deps = [
  #     ];
  #   };
  # };
}
