{
  home.stateVersion = "25.05";
  imports = [
    ./all/bash.nix
    ./all/zsh.nix
    ./all/vscode-server.nix
    ./all/git.nix # used in home-default
    # ./all/rio.nix
  ];
}
