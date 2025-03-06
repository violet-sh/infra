{ inputs, ... }:
{
  imports = with inputs; [
    catppuccin.homeManagerModules.catppuccin
    nix-index-database.hmModules.nix-index

    ../../modules/home

    ./common
    ./desktop
  ];
}
