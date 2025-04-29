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

    ../../presets/nixos/laptop.nix
  ];

  ### Hardware
  hardware = {
    graphics.extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      vpl-gpu-rt
    ];
  };

  environment.systemPackages = with pkgs; [
    intel-gpu-tools
  ];

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
  };

  ### Networking
  networking = {
    hostName = "zeus";
    hostId = "deadb33f";
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
        "10.8.0.2/16"
        "fd47:4161:82f9::2/64"
      ];
      privateKeyFile = config.age.secrets.zeus_wg0_key.path;
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
