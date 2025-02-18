{
  config,
  lib,
  pkgs,
  ...
}:

let
  isUnstable = config.boot.zfs.package == pkgs.zfsUnstable;
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (
      (!isUnstable && !kernelPackages.zfs.meta.broken)
      || (isUnstable && !kernelPackages.zfs_unstable.meta.broken)
    )
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  ### Module imports
  imports = [
    ./hardware-configuration.nix
  ];

  ### Hardware
  hardware = {
    graphics.extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      vpl-gpu-rt
    ];
  };

  ### Boot
  boot = {
    loader.grub = {
      enable = true;
      zfsSupport = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      mirroredBoots = [
        {
          devices = [ "nodev" ];
          path = "/boot";
        }
      ];
    };

    kernelPackages = latestKernelPackage;
  };

  ### Load secrets
  age.secrets = {
    zeus_wg0_key.file = ../../secrets/zeus_wg0_key.age;
    zeus_wg0_preshared_key.file = ../../secrets/zeus_wg0_preshared_key.age;
  };

  ### Networking
  networking = {
    hostName = "zeus";
    hostId = "deadb33f";
    useDHCP = false;
    dhcpcd.enable = false;
    wireless.enable = false;
    networkmanager.enable = true;

    wireguard.interfaces.wg0 = {
      ips = [
        "10.8.0.2/16"
        "fd47:4161:82f9::2/64"
      ];
      privateKeyFile = config.age.secrets.zeus_wg0_key.path;
      peers = [
        {
          publicKey = "uQKOe+7uF8Jm+98Uc64sEWJpuLpGH/BykXYySHkW6jg=";
          presharedKeyFile = config.age.secrets.zeus_wg0_preshared_key.path;
          allowedIPs = [
            "10.8.0.0/16"
            "fd47:4161:82f9::/64"
          ];
          endpoint = "5.161.106.226:28183";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  ### Services
  services = {
    fwupd.enable = true; # Firmware updater
    thermald.enable = true; # Intel CPU thermal daemon
    zfs.autoScrub.enable = true; # Run ZFS scrubs automatically
    fprintd.enable = true; # Fingerprint demon

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  ## Systemd services
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  ### Users
  users.users.tibs = {
    extraGroups = [ "networkmanager" ];
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "24.05";
  # ======================== DO NOT CHANGE THIS ========================
}
