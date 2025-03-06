{ pkgs, ... }:
{
  home.packages = with pkgs; [
    obs-studio
    obs-studio-plugins.wlrobs
    obs-studio-plugins.obs-vkcapture
    obs-studio-plugins.obs-webkitgtk
    obs-studio-plugins.obs-pipewire-audio-capture
  ];
}
