{pkgs,flake,...}:let
  inherit (flake.config.me) username;
in{
  environment.systemPackages = with pkgs; [
    android-studio
    clang
    cmake
    flutter
    ninja
    pkg-config
  ];
  android_sdk.accept_license = true;

  programs = {
    adb.enable = true;
  };

  users.users.username = {
    extraGroups = [
      "adbusers"
    ];
  };

  system.userActivationScripts = {
    stdio = {
      text = ''
        rm -f ~/Android/Sdk/platform-tools/adb
        ln -s /run/current-system/sw/bin/adb ~/Android/Sdk/platform-tools/adb
      '';
      deps = [
      ];
    };
  };
}