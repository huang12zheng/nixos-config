# homeModules =
#   forAllNixFiles "${self}/modules/home" (fn: fn);
# { config,...}:
{ config,pkgs,flake,...}:
let
  inherit (flake.config) opt;
in
{
  home.stateVersion = "24.05";

  
  # imports = ext1; 
  imports =[
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
  
  home.packages = with pkgs; lib.optional (!opt.isCliORWSL2) [
    feishu
    (wechat-uos.override {
      buildFHSEnv = args: buildFHSEnv (args // {
        # bubble wrap wechat-uos's home directory
        extraBwrapArgs = [
          "--bind ${config.home.homeDirectory}/.local/share/wechat-uos /home"
          "--chdir /home"
        ];
      });
      uosLicense = fetchurl {
        url = "https://github.com/xddxdd/nur-packages/raw/master/pkgs/uncategorized/wechat-uos/license.tar.gz";
        sha256 = "0sdx5mdybx4y489dhhc8505mjfajscggxvymlcpqzdd5q5wh0xjk";
      };
    })
    nur.repos.linyinfeng.wemeet
    nur.repos.xddxdd.dingtalk
    libreoffice
  ];
}
