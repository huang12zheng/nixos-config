{ config, pkgs, inputs, system, rosettaPkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    aria2
    ripgrep
    sd
    tig
    tmux
    pass
    pandoc

    mpv
    youtube-dl

    # We must install Agda globally so that Doom-Emacs' agda config can
    # recognize it. It doesn't matter that our projects use Nix/direnv.
    # 
    # Emacs configuration system assumes global state, and is thus shit. We just work with it.
    # https://github.com/hlissner/doom-emacs/blob/f458f9776049fd7e9523318582feed682e7d575c/modules/lang/agda/config.el#L3-L8
    (rosettaPkgs.agda.withPackages (p: [ p.standard-library ]))
    rosettaPkgs.idris2
    #rosettaPkgs.coq
    # (rosettaPkgs.haskellPackages.callHackage "agda-language-server" "0.2.1" { })
  ];

  nix.extraOptions = ''
    extra-platforms = aarch64-darwin x86_64-darwin
    experimental-features = nix-command flakes
  '';

  launchd.user.agents.banyan =
    let
      banyan = inputs.banyan.outputs.defaultPackage.${system};
    in
    {
      serviceConfig = {
        ProgramArguments =
          [ "${banyan}/bin/banyan" ];
        EnvironmentVariables = {
          PORT = "9909";
        };
        WorkingDirectory = "/Users/srid/Banyan";
      };
    };

  nixpkgs.config.allowBroken = true;

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
