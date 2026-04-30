{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ./hardware-configuration.nix

    ../../presets/nixos/server.nix
  ];

  hardware = {
    enableRedistributableFirmware = true;
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
      "net.ipv6.conf.all.accept_ra" = 0;
    };
  };

  age.secrets = {
    boreas_wg0_key.file = ../../secrets/boreas_wg0_key.age;
    boreas_wg1_key.file = ../../secrets/boreas_wg1_key.age;
  };

  networking = {
    hostName = "boreas";
    wireguard.interfaces.wg1 = {
      ips = "10.200.255.3/32";
      privateKeyFile = config.age.secrets.boreas_wg1_key.path;
      peers = [
        {
          name = "vtix";
          publicKey = "pSNmGicWbgR1YnxUP/cU7LWSRXU2WYUP7jzFs624kws=";
          allowedIPs = [ "10.200.0.0/16" ];
          endpoint = "132.198.104.152:51820";
        }
      ];
    };
  };

  modules.wireguard = {
    enable = true;
    ips = [
      "10.8.0.9/24"
      "fd47:4161:82f9::9/64"
    ];
    privateKeyFile = config.age.secrets.boreas_wg0_key.path;
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "26.05";
  # ======================== DO NOT CHANGE THIS ========================
}
