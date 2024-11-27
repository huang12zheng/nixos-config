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

    (self + /modules/nixos/linux/gui/desktopish/vscode.nix)
    # (self + /modules/nixos/linux/flutter.nix)
    (self + /modules/nixos/linux/gui/gnome.nix)
    (self + /modules/nixos/linux/gui/desktopish/fonts.nix)
    # (self + /modules/nixos/linux/gui/_1password.nix)
  ];
  users.users.${username}.isNormalUser = true;
  home-manager.users.${username} = {
    imports = [
      (self + /configurations/home/${username}.nix)
    ];
  };

  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.fprintd.enable = true;
  services.syncthing = { enable = true; user = username; dataDir = "/home/${username}/Documents"; };


  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;


  programs.nix-ld.enable = true; # for vscode server

  # Workaround the annoying `Failed to start Network Manager Wait Online` error on switch.
  # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;
}
