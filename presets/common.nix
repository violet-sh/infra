{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
    inputs.home-manager.nixosModules.home-manager
    inputs.ragenix.nixosModules.default

    ../modules
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
      extra-substituters = [ "https://nix-community.cachix.org" ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      inputs.nur.overlay
      inputs.rust-overlay.overlays.default
      (self: super: { utillinux = super.util-linux; })
    ];
  };

  ### Temporary Override
  nixpkgs.config.permittedInsecurePackages = [ "electron-29.4.6" ];

  ### System meta
  time.timeZone = lib.mkDefault "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  ### Common packages
  environment.systemPackages = with pkgs; [
    inetutils
    iperf3
    ldns # drill
    lm_sensors
    neofetch
    pciutils # lspci
    usbutils # lsusb
    util-linux # lsblk
    wget
  ];

  ### Common programs
  programs = {
    git.enable = true;
    htop.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  ### Common services
  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
  };

  ### Users
  users.users.tibs = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  ### Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
    };
    users.tibs = import ../home;
  };
}
