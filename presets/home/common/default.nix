{
  age,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./catppuccin.nix
    ./development.nix
    ./neovim.nix
    ./shell.nix
  ];

  home = {
    username = "tibs";
    homeDirectory = "/home/tibs";

    packages = with pkgs; [
      # Tools
      bombardier
      chafa
      diskus
      dogdns
      doggo
      dust
      file
      has
      hexyl
      hyperfine
      nmap
      packwiz
      pastel
      pigz
      procs
      q
      tokei
      trippy
      undollar
      websocat

      # Fun
      charasay
      cmatrix
      fortune-kind
      globe-cli
      kittysay
      lolcat
      neo-cowsay
      nyancat
      pipes-rs
      sl

      # APIs
      cloudflared

      # Libraries
      grc
    ];

    file = {
      ".local/bin/nuh".source = ../../../scripts/nuh.sh;
      ".local/bin/zls".source = ../../../scripts/zls.sh;

      ".ssh/id_ed25519".source = config.lib.file.mkOutOfStoreSymlink age.secrets.ssh_key.path;
      ".ssh/id_ed25519.pub".text =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQ2j1Tc6TMied/Hft9RWZpB+OFlN+TgsDikeJpe8elQ";
    };
  };

  programs = {
    bat.enable = true;
    bottom.enable = true;
    broot.enable = true;
    btop.enable = true;
    eza.enable = true;
    fastfetch.enable = true;
    fd.enable = true;
    fzf.enable = true;
    gpg.enable = true;
    hyfetch.enable = true;
    jq.enable = true;
    lazygit.enable = true;
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
    ripgrep.enable = true;

    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    gh-dash.enable = true;

    tealdeer.enable = true;

    home-manager.enable = true; # Let Home Manager manage itself
  };

  # ======================== DO NOT CHANGE THIS ========================
  home.stateVersion = "24.05";
  # ======================== DO NOT CHANGE THIS ========================
}
