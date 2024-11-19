# Top-level configuration for everything in this repo.
#
# Values are set in 'config.nix' in repo root.
{ lib, ... }:
let
  userSubmodule = lib.types.submodule {
    options = {
      username = lib.mkOption {
        type = lib.types.str;
      };
      fullname = lib.mkOption {
        type = lib.types.str;
      };
      email = lib.mkOption {
        type = lib.types.str;
      };
      sshKey = lib.mkOption {
        type = lib.types.str;
        description = ''
          SSH public key
        '';
      };
    };
  };
in
{
  imports = [
    ../../config.nix
  ];
  options = {
    me = lib.mkOption {
      type = userSubmodule;
    };
    opt = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {
        isMinimalConfig = false;
        proxyPort = 7890;
        # isCli = (builtins.getEnv "DISPLAY")=="";
        isCli = (builtins.getEnv "DISPLAY" == "")
          || (builtins.getEnv "XDG_SESSION_TYPE" == "");
        isGui = (builtins.getEnv "DISPLAY")!="";
        isNixOnDroid = (builtins.getEnv "USER")=="nix-on-droid";
        isWSL2 = (builtins.getEnv "WSL_DISTRO_NAME")!="";
        isCliORWSL2 = (builtins.getEnv "DISPLAY" == "")
          || (builtins.getEnv "XDG_SESSION_TYPE" == "")
          || (builtins.getEnv "WSL_DISTRO_NAME")!="";
      };
    };
  };
}
