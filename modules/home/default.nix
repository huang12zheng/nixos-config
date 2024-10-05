{
  home.stateVersion = "22.11";
  imports = [
    ./all/tmux.nix
    ./all/neovim.nix
    ./all/emacs.nix
    # ./helix.nix
    ./all/ssh.nix
    ./all/starship.nix
    ./all/terminal.nix
    ./all/nix.nix
    ./all/git.nix
    ./all/direnv.nix
    ./all/zellij.nix
    # ./nushell.nix
    ./all/just.nix
    # ./powershell.nix
    ./all/juspay.nix
  ];
}