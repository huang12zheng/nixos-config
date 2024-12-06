{ flake, config, pkgs, lib, ... }:
let
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/mobile/androidenv/compose-android-packages.nix
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    # buildToolsVersions = [ "30.0.2" "34.0.0" ];
    # buildToolsVersions = [ "34.0.0" ];
    # platformVersions = [ "34" ];
    abiVersions = [ "x86_64" "armeabi-v7a" "arm64-v8a" ];
    includeNDK = true;
    includeEmulator = true;
    includeSystemImages = true;
  };
  androidSdk = androidComposition.androidsdk;
  pinnedJDK = pkgs.jdk17;
in
{

  home.packages = with pkgs; [
    just
    clang
    cmake
    ninja
    pkg-config
    gtk3
    pinnedJDK
    jdk17
    androidSdk
    android-tools
    flutter
    cargo
    rustc
    cargo-binstall
    cargo-insta
    rust-cbindgen
    # (pkgs.androidenv.emulateApp {
    #   name = "emulate-34";
    #   platformVersion = "34";
    #   abiVersion = "x86_64"; # armeabi-v7a, mips, x86_64
    #   systemImageType = "google_apis_playstore";
    # })

  ];
  home.sessionVariables = {
    JAVA_HOME = pinnedJDK;
    binstalls = lib.strings.concatStringsSep " " [
      "flutter_rust_bridge_codegen"
      "cargo-insta"
    ];
    NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE = 1;
    # ANDROID_HOME = androidSdk;
    ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
    CHROME_EXECUTABLE = pkgs.google-chrome;
  };
  home.sessionPath = [ "$HOME/.cargo/bin" "$ANDROID_SDK_ROOT/tools/bin" ];

}
