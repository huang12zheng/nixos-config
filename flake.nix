{
  description = "Srid's NixOS configuration";

  inputs = {
    # To update nixpkgs (and thus NixOS), pick the nixos-unstable rev from
    # https://status.nixos.org/
    # 
    # This ensures that we always use the official nix cache.
    nixpkgs.url = "github:nixos/nixpkgs/5181d5945eda382ff6a9ca3e072ed6ea9b547fee";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-vscode-server.url = "github:iosmanthus/nixos-vscode-server/add-flake";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    hercules-ci-agent.url = "github:hercules-ci/hercules-ci-agent/master";
    nixos-shell.url = "github:Mic92/nixos-shell";

    # Vim & its plugins (not in nixpkgs)
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.neovim-flake.url = "github:neovim/neovim/v0.7.0?dir=contrib";
    vim-eldar.url = "github:agude/vim-eldar";
    vim-eldar.flake = false;
    himalaya.url = "github:soywod/himalaya";
    himalaya.flake = false;
  };

  outputs = inputs@{ self, home-manager, nixpkgs, darwin, ... }:
    let
      overlayModule =
        {
          nixpkgs.overlays = [
            (inputs.emacs-overlay.overlay)
            (inputs.neovim-nightly-overlay.overlay)
          ];
        };
    in
    {
      # Configurations for Linux (NixOS) systems
      nixosConfigurations =
        let
          system = "x86_64-linux";
          pkgs = nixpkgs.legacyPackages.${system};
          # Configuration common to all Linux systems
          commonFeatures = [
            overlayModule
            ./features/self-ide.nix
            ./features/takemessh
            ./features/caches
            ./features/current-location.nix
          ];
          homeFeatures = [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit system inputs; };
              home-manager.users.srid = {
                imports = [
                  ./home/tmux.nix
                  ./home/git.nix
                  ./home/neovim.nix
                  ./home/starship.nix
                  ./home/terminal.nix
                  ./home/direnv.nix
                ];

                programs.bash = {
                  enable = true;
                } // (import ./home/shellcommon.nix { inherit pkgs; });
              };
            }
          ];
          mkLinuxSystem = extraModules: nixpkgs.lib.nixosSystem {
            inherit system pkgs;
            # Arguments to pass to all modules.
            specialArgs = { inherit system inputs; };
            modules =
              commonFeatures ++ homeFeatures ++ extraModules;
          };
        in
        {
          # My beefy development computer
          now = mkLinuxSystem
            [
              ./hosts/hetzner/ax101.nix
              ./features/server/harden.nix
              ./features/server/devserver.nix
              ./features/hercules.nix
            ];
          # This is run in qemu only.
          # > nixos-shell --flake github:srid/nixos-config#corsair
          corsair = pkgs.lib.makeOverridable nixpkgs.lib.nixosSystem {
            inherit system pkgs;
            specialArgs = { inherit system inputs; };
            modules = [
              inputs.nixos-shell.nixosModules.nixos-shell
              {
                virtualisation = {
                  memorySize = 8 * 1024;
                  cores = 2;
                  diskSize = 20 * 1024;
                };
                environment.systemPackages = with pkgs; [
                  protonvpn-cli
                  aria2
                ];
                nixos-shell.mounts = {
                  mountHome = false;
                  mountNixProfile = false;
                  extraMounts."/Downloads" = {
                    target = "/home/srid/Downloads";
                    cache = "none";
                  };
                };
              }
            ];
          };
        };

      # Configurations for macOS systems (using nix-darwin)
      darwinConfigurations."air" =
        let
          system = "aarch64-darwin";
          mkMacosSystem = darwin.lib.darwinSystem;
        in
        mkMacosSystem {
          inherit system;
          specialArgs = {
            inherit inputs system;
            rosettaPkgs = import nixpkgs { system = "x86_64-darwin"; };
          };
          modules = [
            overlayModule
            ./hosts/darwin.nix
            ./features/caches/oss.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit system inputs; };
              home-manager.users.srid = { pkgs, ... }: {
                imports = [
                  ./home/git.nix
                  ./home/tmux.nix
                  ./home/neovim.nix
                  ./home/email.nix
                  ./home/terminal.nix
                  ./home/direnv.nix
                  ./home/starship.nix
                ];
                programs.zsh = {
                  enable = true;
                  initExtra = ''
                    export PATH=$HOME/.nix-profile/bin:/run/current-system/sw/bin/:$PATH
                  '';
                } // (import ./home/shellcommon.nix { inherit pkgs; });
                home.stateVersion = "21.11";
              };
            }
          ];
        };
    };

}
