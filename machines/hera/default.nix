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
    hera_wg0_key.file = ../../secrets/hera_wg0_key.age;
  };

  ### Networking
  networking = {
    hostName = "hera";
    hostId = "b0cc50d1";
    useDHCP = false;
    dhcpcd.enable = false;
    wireless.enable = false;
    networkmanager.enable = true;
  };

  ### Modules
  modules = {
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
    fwupd.enable = true; # Firmware updater
    zfs.autoScrub.enable = true; # Run ZFS scrubs automatically

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
