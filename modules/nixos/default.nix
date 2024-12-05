# Configuration common to all Linux systems
{ flake, ... }:

let
  inherit (flake) config inputs;
  inherit (inputs) self;
  inherit (flake.config.opt) github_token;
in
{
  imports = [
    self.nixosModules.common
    self.nixosModules.flutter
    # inputs.ragenix.nixosModules.default # Used in github-runner.nix & hedgedoc.nix
    ./linux/current-location.nix
    ./linux/light.nix
    ./linux/self-ide.nix
    {
      nix.settings = {
        access-tokens = [
          "github.com=${github_token}"
        ];
      };
    }
  ];
  environment.variables.GITHUB_TOKEN = github_token;
}
