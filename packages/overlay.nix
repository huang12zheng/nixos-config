{ flake, system, ... }:

self: super: {
  fuckport = self.callPackage ./fuckport.nix { };
  nixci = flake.inputs.nixci.packages.${system}.default;
  nix-health = flake.inputs.nix-browser.packages.${system}.nix-health;
  actual = flake.inputs.actual.packages.${system}.default;
}
