{ pkgs, ... }:
{
  home.packages = with pkgs.jetbrains; [
    clion
    goland
    idea-ultimate
    pycharm-professional
    rider
    rust-rover
    webstorm
  ];
}
