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
      device = "/dev/vda";
    };
  };

  age.secrets = {
    hera_wg0_key.file = ../../secrets/zephyrus_wg0_key.age;
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
      # ipv6.addresses = [
      #   {
      #     address = "2602:f831::4665:8aff:fee3:5ae8";
      #     prefixLength = 64;
      #   }
      # ];
    };

    defaultGateway = {
      address = "199.127.129.129";
      interface = "enp1s0";
    };
    # defaultGateway6 = {
    #   address = "<gateway_address>";
    #   interface = "enp1s0";
    # };
  };

  modules = {
    zfs.enable = true;

    wireguard = {
      enable = true;
      ips = [
        "10.8.0.7/16"
        "fd47:4161:82f9::7/64"
      ];
      privateKeyFile = config.age.secrets.zephyrus_wg0_key.path;
    };
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "25.11";
  # ======================== DO NOT CHANGE THIS ========================
}
