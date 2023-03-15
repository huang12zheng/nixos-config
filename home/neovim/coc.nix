{ pkgs, system, ... }:
{
  programs.neovim = {
    coc = {
      enable = true;
    };

    extraPackages = [
      pkgs.nodejs # coc requires nodejs
    ];
  };
}
