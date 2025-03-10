{ flake, pkgs, lib, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
  inherit (flake.config.me) username;
in
{

  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnsupportedSystem = true;
      allowUnfree = true;
      android_sdk.accept_license = true;
    };
    overlays = lib.attrValues self.overlays;
  };
  nix = {
    # Choose from https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=nix
    # package = pkgs.nixVersions.latest;

    nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
    registry.nixpkgs.flake = flake.inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs

    settings = {
      max-jobs = "auto";
      experimental-features = "nix-command flakes";
      # I don't have an Intel mac.
      # extra-platforms = lib.mkIf pkgs.stdenv.isDarwin "aarch64-darwin x86_64-darwin";
      # Nullify the registry for purity.
      # flake-registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';
      trusted-users = [ "root" (lib.mkIf pkgs.stdenv.isLinux "@wheel") username "nixos" ];
      # trusted-users = [ "root" (if pkgs.stdenv.isDarwin then username else "@wheel") username "nixos" ];
      # trusted-users = [ "root" (if pkgs.stdenv.isDarwin then flake.config.me.username else "@wheel") "nixos" ];
    };
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
 