{ config, pkgs, ... }:
{
  # Module imports
  imports = [
    ./hardware-configuration.nix

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

  networking = {
    hostName = "zephyrus";
    hostId = "7920a53b";
    useNetworkd = true;
    interfaces.enp1s0 = {
      ipv4.addresses = [
        {
          address = "199.127.129.190";
          prefixLength = 25;
        }
      ];
      ipv6.addresses = [
        {
          address = "2602:f831::4665:8aff:fee3:5ae8";
          prefixLength = 64;
        }
      ];
    };

    defaultGateway = {
      address = "199.127.129.129";
      interface = "enp1s0";
    };
    defaultGateway6 = {
      address = "2a0a:8dc0:2000:97::1";
      interface = "enp1s0";
    };
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "25.11";
  # ======================== DO NOT CHANGE THIS ========================
}
