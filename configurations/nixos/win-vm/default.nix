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
    # (self + /modules/nixos/linux/gui/hyprland.nix)
    (self + /modules/nixos/linux/gui/gnome.nix)
    (self + /modules/nixos/linux/gui/desktopish/fonts.nix)
    # (self + /modules/nixos/linux/gui/desktopish/steam.nix)
    # (self + /modules/nixos/linux/gui/_1password.nix)
  ];

  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.fprintd.enable = true;
  services.syncthing = { enable = true; user = username; dataDir = "/home/${username}/Documents"; };

  programs.nix-ld.enable = true; # for vscode server

  # Workaround the annoying `Failed to start Network Manager Wait Online` error on switch.
  # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;
}
