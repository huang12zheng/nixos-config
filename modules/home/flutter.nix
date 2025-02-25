{ flake, config, pkgs, lib, ... }:
let
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/mobile/androidenv/compose-android-packages.nix
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    # buildToolsVersions = [ "30.0.2" "34.0.0" ];
    # buildToolsVersions = [ "34.0.0" ];
    # platformVersions = [ "34" ];
    abiVersions = [ "x86_64" ];
    # includeNDK = true;
    # includeEmulator = true;
    # includeSystemImages = true;
  };
  androidSdk = androidComposition.androidsdk;
  pinnedJDK = pkgs.jdk17;
  clang_path = pkgs.llvmPackages.libclang.lib;
in
{

  home.packages = with pkgs;
    [
      just
      clang
      clang_path
      protobuf
      cmake
      ninja
      pkg-config
      gtk3
      pinnedJDK
      jdk17
      androidSdk
      android-tools
      flutter
      rustup

      # cargo
      # rustc
      # rustfmt
      cargo-binstall
      cargo-insta
      rust-cbindgen
      perl
      mold
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
      "cargo-cache"
      "sccache"
      "rust"
      "cargo-component"
      "twiggy"
      "cargo-generate"
      "cargo-clean-all"
      "wit-bindgen-cli"
    ];
    NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE = 1;
    # ANDROID_HOME = androidSdk;
    ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
    CHROME_EXECUTABLE = pkgs.google-chrome;
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    LIBCLANG_PATH = "${clang_path}/lib";
    RUSTC_WRAPPER = "$HOME/.cargo/bin/sccache";
    CARGO_TARGET_DIR = "$HOME/.cargo/target/shared";
    RUSTC_LINKER = "${pkgs.llvmPackages.clangUseLLVM}/bin/clang";
    RUSTFLAGS = "-Clink-arg=-fuse-ld=${pkgs.mold}/bin/mold";
    # RUSTFLAGS = "-Zlocation-detail=none -Zfmt-debug=none";
  };
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$ANDROID_SDK_ROOT/tools/bin"
    "$HOME/Gist/alias_command"
  ];

}
