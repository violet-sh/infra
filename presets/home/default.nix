{ inputs, ... }:
{
  imports = with inputs; [
    catppuccin.homeModules.catppuccin
    nix-index-database.homeModules.nix-index

    ../../modules/home

    ./common
  ];
}
