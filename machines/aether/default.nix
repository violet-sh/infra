{ config, pkgs, ... }:
{
  # Module imports
  imports = [
    # ./hardware-configuration.nix

    ../../presets/nixos/server.nix
  ];

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

  age.secrets = {
    aether_wg0_key.file = ../../secrets/aether_wg0_key.age;
  };

  networking = {
    hostName = "aether";
    hostId = "ff85a7eb";
    useDHCP = false;
    dhcpcd.enable = false;
    wireless.enable = false;
  };

  modules = {
    zfs.enable = true;

    wireguard = {
      enable = true;
      ips = [
        "10.8.0.1/16"
        "fd47:4161:82f9::1/64"
      ];
      privateKeyFile = config.age.secrets.aether_wg0_key.path;
    };

    caddy = {
      enable = true;
      metrics = true;
    };

    forgejo = {
      enable = true;
      hostname = "git.tibs.gay";
      port = 2000;
    };

    reposilite = {
      enable = true;
      hostname = "maven.tibs.gay";
      port = 3000;
    };

    woodpecker-server = {
      enable = true;
      hostname = "ci.tibs.gay";
      port = 4000;
      orgs = [ "community-tbd" ];
      admin = [ "TibiNonEst" ];
    };
  };

  services = {
    fwupd.enable = true; # Firmware updater
  };
}
