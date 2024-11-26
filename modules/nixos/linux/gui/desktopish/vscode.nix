{ pkgs, ... }: {
  /* imports = [
    flake.inputs.nixos-vscode-server.nixosModules.default
    ];
    services.vscode-server.enable = true;
    services.vscode-server.installPath = "~/.vscode-server-insiders";
  */

  # https://unix.stackexchange.com/q/659901/14042
  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override
      {
        vscodeExtensions = with vscode-extensions; [
          bbenoist.nix
          ms-python.python
          ms-azuretools.vscode-docker
          ms-vscode-remote.remote-ssh
          streetsidesoftware.code-spell-checker
          wholroyd.jinja
          ms-vscode-remote.remote-containers
          tamasfe.even-better-toml
          rust-lang.rust-analyzer
          # Nash.awesome-flutter-snippets
          # aaron-bond.better-comments
          # jeff-hykin.better-dockerfile-syntax
          # MS-CEINTL.vscode-language-pack-zh-hans
          # vivaxy.vscode-conventional-commits
          # serayuzgur.crates
          # usernamehw.errorlens
          # Dart-Code.flutter
          # circlecodesolution.ccs-flutter-color
          # robert-brunhage.flutter-riverpod-snippets
          eamodio.gitlens
          # rsbondi.highlight-words
          # mitsuhiko.insta
          # kokakiwi.vscode-just
          yzhang.markdown-all-in-one
      ];
    })
    vscode
    # nodejs-16_x # Need this for https://nixos.wiki/wiki/Vscode server
  ];

  # https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = "524288";
  };
}
