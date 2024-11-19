{ inputs, ... }:
let inherit (inputs) self;
in
{
  imports = [
    inputs.nixos-unified.flakeModules.default
    inputs.nixos-unified.flakeModules.autoWire
  ];
  perSystem = { self', lib, system, ... }: {
    packages.default = self'.packages.activate;

    # Flake inputs we want to update periodically
    # Run: `nix run .#update`.
    nixos-unified = {
      primary-inputs = [
        "nixpkgs"
        "home-manager"
        "nix-darwin"
        "nixos-unified"
        "nix-index-database"
        # "nixvim"
        "omnix"
      ];
    };
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = lib.attrValues self.overlays;
      config.allowUnfree = true;
    };
  };
}
