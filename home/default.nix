{ inputs, pkgs, ... }:

{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin

    ./catppuccin.nix
    ./development.nix
    ./firefox.nix
    ./fish.nix
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

    home-manager.enable = true; # Let Home Manager manage itself
  };

  # ======================== DO NOT CHANGE THIS ========================     
  home.stateVersion = "24.05";
  # ======================== DO NOT CHANGE THIS ========================
}
