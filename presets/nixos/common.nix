{
  config,
  inputs,
  lib,
  outputs,
  pkgs,
  ...
}:
{
  imports = with inputs; [
    catppuccin.nixosModules.catppuccin
    home-manager.nixosModules.home-manager
    ragenix.nixosModules.default
  ];

  ### Common Nix settings
  nix = {
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "recursive-nix"
      ];
      system-features = [ "recursive-nix" ];
      trusted-users = [ "tibs" ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;

    overlays = with inputs; [
      outputs.overlays.packages

      nur.overlays.default
      rust-overlay.overlays.default
    ];
  };

  environment.etc = {
    "nixos".source = "/home/tibs/infra";
  };

  ### System meta
  time.timeZone = lib.mkDefault "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  ### Common packages
  environment.systemPackages = with pkgs; [
    dmidecode
    inetutils
    iperf3
    ldns # drill
    lm_sensors
    lshw
    neofetch
    pciutils # lspci
    unzip
    usbutils # lsusb
    util-linux # lsblk
    wget
  ];

  ### Modules
  modules = {
    blocky.enable = lib.mkDefault true;
    chrony.enable = lib.mkDefault true;
  };

  ### Common programs
  programs = {
    htop.enable = true;
    mtr.enable = true;
    nix-ld.enable = true;

    git = {
      enable = true;
      lfs.enable = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  ### Common services
  services = {
    fwupd.enable = true; # Firmware updater
  };

  ### Networking
  networking = {
    domain = "tibs.gay";
    useDHCP = false;
    dhcpcd.enable = false;
    firewall.enable = true;
    nftables.enable = true;
    search = [ "as215207.net" ];
  };

  ### Users
  users.users.tibs = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQ2j1Tc6TMied/Hft9RWZpB+OFlN+TgsDikeJpe8elQ"
    ];
  };

  ### Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs =
      let
        age = config.age;
      in
      {
        inherit age inputs;
      };
    users.tibs = import ../home;
  };

  ### Setup ragenix
  age = {
    identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    # Load ssh key from age file for home-manager
    secrets.ragenix_key = {
      file = ../../secrets/ragenix_key.age;
      owner = "tibs";
      group = "users";
    };
  };
}
