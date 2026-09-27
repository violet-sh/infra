{ ... }:
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
    hostName = "boreas";
    hostId = "18541de";
    useNetworkd = true;
    interfaces.ens18 = {
      ipv4.addresses = [
        {
          address = "23.167.201.6";
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          address = "2602:f9c6:100:2001::10f";
          prefixLength = 128;
        }
      ];
    };

    defaultGateway = {
      address = "23.167.201.1";
      interface = "ens18";
    };
    defaultGateway6 = {
      address = "fe80::1e6a:1bff:fe4b:ce21";
      interface = "ens18";
    };
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "26.05";
  # ======================== DO NOT CHANGE THIS ========================
}
