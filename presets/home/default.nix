{
  age,
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = with inputs; [
    catppuccin.homeManagerModules.catppuccin

    ./catppuccin.nix
    ./development.nix
    ./firefox.nix
    ./jetbrains.nix
    ./neovim.nix
    ./obs.nix
    ./shell.nix
    ./sway.nix
    ./waybar

    ../../modules/home
  ];

  home = {
    username = "tibs";
    homeDirectory = "/home/tibs";

    packages = with pkgs; [
      # Browsers
      brave
      mullvad-browser
      tor-browser

      # Tools
      bombardier
      broot
      chafa
      dogdns
      file
      has
      hexyl
      hyperfine
      nix-index
      packwiz
      pastel
      pigz
      procs
      q
      ripgrep
      tealdeer
      tokei
      trippy
      undollar
      websocat

      # Fun
      cmatrix
      cowsay
      fortune-kind
      lolcat
      nyancat
      pipes-rs
      sl

      # APIs
      cloudflared

      # Apps
      aseprite
      coppwr
      foliate
      gimp
      handbrake
      helvum
      keepassxc
      kdePackages.filelight
      musescore
      newsflash
      prismlauncher
      pwvucontrol
      simplex-chat-desktop
      slack
      sparrow-wifi
      spotify
      teams-for-linux
      transmission_4-qt
      vesktop
      video-trimmer
      vlc
      zoom-us

      # Libraries
      grc

      # Misc
      networkmanagerapplet
    ];

    shellAliases = {
      cat = "bat -pp";
      less = "bat --style plain --paging always";
      lzg = "lazygit";
      sude = "sudo -E";
    };

    file = {
      ".local/bin/nuh".source = ../../scripts/nuh.sh;
      ".local/bin/zls".source = ../../scripts/zls.sh;

      ".ssh/id_ed25519".source = config.lib.file.mkOutOfStoreSymlink age.secrets.ssh_key.path;
      ".ssh/id_ed25519.pub".text =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQ2j1Tc6TMied/Hft9RWZpB+OFlN+TgsDikeJpe8elQ";
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
    fastfetch.enable = true;
    fd.enable = true;
    fzf.enable = true;
    gpg.enable = true;
    hyfetch.enable = true;
    jq.enable = true;
    lazygit.enable = true;
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

    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    gh-dash.enable = true;

    home-manager.enable = true; # Let Home Manager manage itself
  };

  # ======================== DO NOT CHANGE THIS ========================
  home.stateVersion = "24.05";
  # ======================== DO NOT CHANGE THIS ========================
}
