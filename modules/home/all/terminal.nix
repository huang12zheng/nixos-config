# Platform-independent terminal setup
{ flake, pkgs, ... }:

let
  inherit (flake) inputs;
in
{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];
  home.packages = with pkgs; [
    # Unixy tools
    ripgrep
    fd
    sd
    # wget # had in system
    moreutils # ts, etc.
    gnumake
    # Broken, https://github.com/NixOS/nixpkgs/issues/299680
    # ncdu

    # Useful for Nix development
    # omnix
    nixpkgs-fmt
    just

    # Publishing
    asciinema

    # Dev
    gh
    fuckport
    entr
    git-merge-and-delete

    # Fonts
    cascadia-code
    monaspace

    # Txns
    hledger
    hledger-web

    gnupg
  ];

  fonts.fontconfig.enable = true;

  home.shellAliases = {
    e = "nvim";
    g = "git";
    gc = "git clone";
    lg = "lazygit";
    l = "ls";
    beep = "say 'beep'";
    b = "bat";
    open = "nautilus";
    nix-gc = "nix-collect-garbage && cargo clean-all --keep-days 7 ~";
  };

  programs = {
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    nix-index-database.comma.enable = true;
    lsd = {
      enable = true;
      enableAliases = true;
    };
    bat.enable = true;
    autojump.enable = true;
    zoxide.enable = true;
    fzf.enable = true;
    jq.enable = true;
    # htop.enable = true;
  };
}
