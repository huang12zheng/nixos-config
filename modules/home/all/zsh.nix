{ pkgs, lib, ... }:

{
  home.sessionPath = lib.mkIf pkgs.stdenv.isDarwin [
    "/etc/profiles/per-user/$USER/bin"
    "/nix/var/nix/profiles/system/sw/bin"
    "/usr/local/bin"
  ];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
    oh-my-zsh = {
      # ohMyZsh = {
      enable = true;
      plugins = [
        "sudo"
        "vi-mode"
        "web-search"
        # "powerlevel10k"
        "history-substring-search"
      ];
    };
    zplug = {
      enable = true;
      plugins = [
        {
          name = "romkatv/powerlevel10k";
          tags = [ "as:theme" "depth:1" ];
        }
        {
          name = "b4b4r07/enhancd";
        }
      ];
    };


    # envExtra = lib.mkIf pkgs.stdenv.isDarwin ''
    #   # Because, adding it in .ssh/config is not enough.
    #   # cf. https://developer.1password.com/docs/ssh/get-started#step-4-configure-your-ssh-or-git-client
    #   export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
    # '';
  };
}
