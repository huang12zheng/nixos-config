{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
  inherit (flake.config.me) username;
in
{
  imports = [
    self.nixosModules.default
    ./configuration.nix
    inputs.nixos-wsl.nixosModules.wsl
  ];
  # users.users."nixos".isNormalUser = true;
  home-manager.users."nixos" = {
    imports = [
      (self + /configurations/home/nixos.nix)
    ];
  };
  
  services.openssh.enable = true;

  programs.nix-ld.enable = true; # for vscode server

  # Workaround the annoying `Failed to start Network Manager Wait Online` error on switch.
  # https://github.com/NixOS/nixpkgs/issues/180175
  # systemd.services.NetworkManager-wait-online.enable = false;
}
