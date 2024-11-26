{pkgs,flake,...}:let
  inherit (flake.config.me) username;
in{
  environment.systemPackages = with pkgs; [
    clang
    cmake
    android-studio
    flutter
    ninja
    pkg-config
  ];
  android_sdk.accept_license = true;

  programs = {
    adb.enable = true;
  };

  users."${username}" = {
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