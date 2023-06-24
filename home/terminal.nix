{ flake, pkgs, lib, ... }:

# Platform-independent terminal setup
{
  home.packages = with pkgs; [
    # Unixy tools
    ripgrep
    fd

    # Useful for Nix development
    nix-output-monitor
    devour-flake
    nil
    # nixd FIXME: why does this not work?
    flake.inputs.nixd.packages.${pkgs.system}.nixd

    # nixd
    nixpkgs-fmt
    shfmt
  ];

  home.shellAliases = {
    e = "nvim";
    g = "git";
    lg = "lazygit";
    l = lib.getExe pkgs.exa;
  };

  programs = {
    bat.enable = true;
    autojump.enable = false;
    zoxide.enable = true;
    fzf.enable = true;
    jq.enable = true;
    nix-index.enable = true;
    htop.enable = true;
  };
}
