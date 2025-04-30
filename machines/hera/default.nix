{ config, ... }:
{
  ### Module imports
  imports = [
    ./hardware-configuration.nix

    ../../presets/nixos/desktop.nix
  ];

  ### Hardware
  hardware = {
    nvidia.open = false;
  };
  services.xserver.videoDrivers = [ "nvidia" ]; # Is this really needed?

  ### Boot
  boot = {
    loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      mirroredBoots = [
        {
          devices = [ "nodev" ];
          path = "/boot";
        }
      ];
    };
  };

  ### Load secrets
  age.secrets = {
    hera_wg0_key.file = ../../secrets/hera_wg0_key.age;
  };

  ### Networking
  networking = {
    hostName = "hera";
    hostId = "b0cc50d1";
    networkmanager.enable = true;
  };

  ### Modules
  modules = {
    home-manager.desktop = true;
    zfs.enable = true;

    wireguard = {
      enable = true;
      ips = [
        "10.8.0.3/16"
        "fd47:4161:82f9::3/64"
      ];
      privateKeyFile = config.age.secrets.hera_wg0_key.path;
    };
  };

  ### Services
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  ### Users
  users.users.tibs = {
    extraGroups = [ "networkmanager" ];
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "24.05";
  # ======================== DO NOT CHANGE THIS ========================
}
