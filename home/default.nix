{ inputs, pkgs, ... }:

{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin

    ./catppuccin.nix
    ./development.nix
    ./jetbrains.nix
    ./neovim.nix
    ./obs.nix
    ./sway.nix
    ./waybar
  ];

  home = {
    username = "tibs";
    homeDirectory = "/home/tibs";

    packages = with pkgs; [
      brave
      cloudflared
      coppwr
      cowsay
      dogdns
      foliate
      grc
      handbrake
      helvum
      hyperfine
      kdePackages.filelight
      lolcat
      mullvad-browser
      networkmanagerapplet
      newsflash
      packwiz
      prismlauncher
      pwvucontrol
      q
      simplex-chat-desktop
      slack
      spotify
      teams-for-linux
      tor-browser
      transmission_4-qt
      vesktop
      video-trimmer
      vlc
      yarn
      zoom-us
    ];

    shellAliases = {
      zls = "zfs list -o name,mountpoint,mounted,used,available,compression,compressratio,encryption";
      cat = "bat -p";
      less = "bat --style plain --paging always";
    };
  };

  xdg = {
    mimeApps.defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };

    portal = {
      enable = true;
      configPackages = [ pkgs.xdg-desktop-portal-gtk ];
      extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    };
  };

  programs = {
    bat.enable = true;
    bottom.enable = true;
    btop.enable = true;
    eza.enable = true;
    fd.enable = true;
    fzf.enable = true;
    gpg.enable = true;
    hyfetch.enable = true;
    jq.enable = true;
    librewolf.enable = true;
    mangohud.enable = true;

    alacritty = {
      enable = true;
      settings.window.padding = {
        x = 5;
        y = 5;
      };
    };

    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
    };

    firefox = {
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
          honey
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

    fish = {
      enable = true;
      plugins = [
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair.src;
        }
        {
          name = "colored-man-pages";
          src = pkgs.fishPlugins.colored-man-pages.src;
        }
        {
          name = "done";
          src = pkgs.fishPlugins.done.src;
        }
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
        {
          name = "fifc";
          src = pkgs.fishPlugins.fifc.src;
        }
        {
          name = "forgit";
          src = pkgs.fishPlugins.forgit.src;
        }
        {
          name = "fzf-fish";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
        {
          name = "sponge";
          src = pkgs.fishPlugins.sponge;
        }
      ];
    };

    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        astro-build.astro-vscode
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
        denoland.vscode-deno
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
        svelte.svelte-vscode
        tamasfe.even-better-toml
        vadimcn.vscode-lldb
        vscjava.vscode-java-pack
      ];
    };

    home-manager.enable = true; # Let Home Manager manage itself
  };

  # ======================== DO NOT CHANGE THIS ========================     
  home.stateVersion = "24.05";
  # ======================== DO NOT CHANGE THIS ========================
}
