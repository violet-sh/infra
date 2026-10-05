{ config, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    profiles.default = {
      extensions.force = true;
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        catppuccin-web-file-icons
        duckduckgo-privacy-essentials
        fastforwardteam
        firefox-color
        languagetool
        localcdn
        mullvad
        privacy-pass
        pronoundb
        refined-github
        return-youtube-dislikes
        search-by-image
        shinigami-eyes
        snowflake
        sponsorblock
        stylus
        ublock-origin
        user-agent-string-switcher
      ];
    };
  };
}
