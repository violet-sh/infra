{ inputs, ... }:
{
  imports = with inputs; [
    catppuccin.homeModules.catppuccin
    nix-index-database.hmModules.nix-index

    ../../modules/home

    ./common
    ./desktop
  ];
}
