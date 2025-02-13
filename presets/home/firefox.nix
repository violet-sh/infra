{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.tibs = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        behave
        betterttv
        bitwarden
        capital-one-eno
        duckduckgo-privacy-essentials
        fastforwardteam
        firefox-color
        keepassxc-browser
        languagetool
        libredirect
        localcdn
        mullvad
        musescore-downloader
        privacy-pass
        pronoundb
        protondb-for-steam
        protoots
        refined-github
        return-youtube-dislikes
        search-by-image
        shinigami-eyes
        simple-translate
        snowflake
        sponsorblock
        stylus
        tab-stash
        ublock-origin
        user-agent-string-switcher
      ];
    };
  };
}
