# homeModules =
#   forAllNixFiles "${self}/modules/home" (fn: fn);
# { config,...}:
{ pkgs, ... }:
{
  home.stateVersion = "24.05";


  # imports = ext1; 
  imports = [
    # ./all/_1password.nix
    # ./all/tmux.nix
    # ./all/neovim
    # ./helix.nix
    ./all/ssh.nix
    ./all/terminal.nix
    ./all/nix.nix
    ./all/git.nix
    ./all/direnv.nix
    # ./all/zellij.nix
    # ./nushell.nix
    ./all/just.nix
    ./all/clash/default.nix

    # ./powershell.nix
    # ./all/juspay.nix
  ];

  home.packages =
    with pkgs;
    # lib.optional (!opt.isCliORWSL2)
    [
      # ccache
      rsync
      screen
      shell-genie
      # nur.repos.linyinfeng.wemeet
      # nur.repos.xddxdd.dingtalk
      nur.repos.linyinfeng.rimePackages.rime-wubi
    ];
  #   ])
  # ++ [ (nur.repos.linyinfeng.rime-wubi) ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    extensions = (with pkgs.vscode-extensions; [
      bbenoist.nix
      # brettm12345.nixfmt-vscode
      b4dm4n.vscode-nixpkgs-fmt
      ms-python.python
      ms-vscode.cpptools
      ms-vsliveshare.vsliveshare
      ms-azuretools.vscode-docker
      streetsidesoftware.code-spell-checker
      wholroyd.jinja
      # ms-vscode-remote.remote-ssh
      # ms-vscode-remote.remote-containers
      ms-vscode-remote.vscode-remote-extensionpack
      tamasfe.even-better-toml
      rust-lang.rust-analyzer
      eamodio.gitlens
      donjayamanne.githistory
      yzhang.markdown-all-in-one
      johnpapa.vscode-peacock
      oderwat.indent-rainbow
      vscode-icons-team.vscode-icons
      alefragnani.project-manager
      aaron-bond.better-comments
      dart-code.flutter

      # SonarSource.sonarlint-vscode
      # sonarsource.sonarlint-vscode (need java)
      # alefragnani.Bookmarks
      alefragnani.bookmarks
      # Codium.codium (now qodo) xxx
      jgclark.vscode-todo-highlight
      # nash.awesome-flutter-snippets
      alexisvt.flutter-snippets
      # jeff-hykin.better-dockerfile-syntax
      # ms-client.vscode-language-pack-zh-hans (only 76)
      # vivaxy.vscode-conventional-commits
      usernamehw.errorlens
      # circlecodesolution.ccs-flutter-color
      # robert-brunhage.flutter-riverpod-snippets
      # rsbondi.highlight-words
      # mitsuhiko.insta
      skellock.just
    ]);
    # (with pkgs.vscode-marketplace;
    # [
    # ]);
    # ]
    # );
    userSettings = {
      editor.rulers = [ 80 100 120 ];
      editor.suggestSelection = "first";
      editor.formatOnSave = true;
      editor.formatOnType = true;
      dartImport.fixOnSave = true;
      dart.debugSdkLibraries = true;
      files.associations = {
        Vagrantfile = "ruby";
      };
      rust-analyzer.linkedProjects = [ "./native/Cargo.toml" ];
      rust-analyzer.lens.enumVariantReferences = true;
      rust-analyzer.lens.references = true;
      rust-analyzer.lens.methodReferences = true;
      # rust-analyzer.lens.references.enumVariant.enable = true;
      # rust-analyzer.lens.references.trait.enable = true;
      rust-analyzer.inlayHints.lifetimeElisionHints.enable = "skip_trivial";
      rust-analyzer.inlayHints.lifetimeElisionHints.useParameterNames = true;
      rust-analyzer.inlayHints.maxLength = 50;
      rust-analyzer.inlayHints.reborrowHints.enable = "always";
      rust-analyzer.hover.actions.references.enable = true;
      rust-analyzer.workspace.symbol.search.kind = "all_symbols";
      search.baseUrl = "https://pub.flutter-io.cn/";
      terminal.integrated.profiles.linux = {
        zsh = {
          path = "zsh";
        };
      };
      terminal.integrated.defaultProfile.linux = "zsh";
      http.proxySupport = "on";
      editor.renderWhitespace = "boundary";
    };
  };
  # dg.desktopEntries = {

  # }
}
