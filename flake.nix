{
  description = "Srid's NixOS configuration";

  inputs = {
    # Principle inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    # darwin.url = "github:lnl7/nix-darwin/master";
    # https://github.com/LnL7/nix-darwin/pull/586
    darwin.url = "github:hercules-ci/nix-darwin/add-hercules-ci-agent";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    nix-serve-ng.url = "github:aristanetworks/nix-serve-ng";

    hci.url = "github:hercules-ci/hercules-ci-agent";

    # Supportive inputs
    nixos-shell.url = "github:Mic92/nixos-shell";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Software inputs
    nixos-vscode-server.url = "github:msteen/nixos-vscode-server";
    nixos-vscode-server.flake = false;
    comma.url = "github:nix-community/comma";
    comma.inputs.nixpkgs.follows = "nixpkgs";
    emanote.url = "github:EmaApps/emanote";

    # Emacs
    emacs-overlay.url = "github:nix-community/emacs-overlay";

    # Vim & its plugins (not in nixpkgs)
    zk-nvim.url = "github:mickael-menu/zk-nvim";
    zk-nvim.flake = false;
    coc-rust-analyzer.url = "github:fannheyward/coc-rust-analyzer";
    coc-rust-analyzer.flake = false;
  };

  outputs = inputs@{ self, home-manager, nixpkgs, darwin, ... }:
    inputs.flake-parts.lib.mkFlake { inherit (inputs) self; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      imports = [
        ./lib.nix
        ./users
        ./home
        ./nixos
        ./nix-darwin
      ];

      flake = {
        # Configurations for Linux (NixOS) systems
        nixosConfigurations = {
          # My Linux development computer (on Hetzner)
          pinch = self.lib.mkLinuxSystem {
            imports = [
              self.nixosModules.default # Defined in nixos/default.nix
              ./systems/hetzner/ax41.nix
              ./nixos/server/harden.nix
              ./nixos/hercules.nix
              # I share my Hetzner server with other people who need it.
              self.nixosModules.guests
              # I host a Nix cache
              (import ./nixos/cache-server.nix {
                keyName = "cache-priv-key";
                domain = "cache.srid.ca";
              })
            ];
          };
        };
        # Configurations for my (only) macOS machine (using nix-darwin)
        darwinConfigurations = {
          default = self.lib.mkMacosSystem {
            imports = [
              self.darwinModules.default # Defined in nix-darwin/default.nix
              ./systems/darwin.nix
            ];
          };
        };
      };

      perSystem = { pkgs, config, inputs', ... }: {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.nixpkgs-fmt
            inputs'.agenix.packages.agenix
          ];
        };
        formatter = pkgs.nixpkgs-fmt;
        apps.default = config.apps.activate;
      };
    };
}
