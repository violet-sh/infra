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

      # GPU CLIs
      glmark2
      mesa-demos
      vulkan-tools

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

      ".ssh/ragenix_ed25519".source = config.lib.file.mkOutOfStoreSymlink age.secrets.ragenix_key.path;
      ".ssh/ragenix_ed25519.pub".text =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfxuU8uMTeoNhOn0AM/LysdLrOxfeYT0c/N+Rh/ChgY";
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
    gh-dash.enable = true;
    gpg.enable = true;
    hyfetch.enable = true;
    jq.enable = true;
    lazygit.enable = true;
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
    ripgrep.enable = true;
    tealdeer.enable = true;

    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    git = {
      enable = true;
      lfs.enable = true;
      userName = "violet";
      userEmail = "vi@violet.sh";
      signing = {
        key = "047833989F50F88F";
        signByDefault = true;
      };
    };

    ssh = {
      enable = true;
      matchBlocks = {
        default = {
          host = "*";
          setEnv = {
            TERM = "xterm-color";
          };
        };

        github = {
          host = "github.com";
          hostname = "github.com";
          user = "git";
        };
      };
    };

    home-manager.enable = true; # Let Home Manager manage itself
  };

  # ======================== DO NOT CHANGE THIS ========================
  home.stateVersion = "24.05";
  # ======================== DO NOT CHANGE THIS ========================
}
