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
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    graphics.extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
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

  ### Networking
  networking = {
    hostName = "zeus";
    hostId = "deadb33f";
    useDHCP = false;
    wireless.enable = false;

    networkmanager = {
      enable = true;
    };

    wireguard.interfaces.wg0 = {
      ips = [
        "10.8.0.3/24"
        "fd47:4161:82f9::3/64"
      ];
      privateKeyFile = config.age.secrets.zeus_wg0_key.path;
      peers = [
        {
          publicKey = "uQKOe+7uF8Jm+98Uc64sEWJpuLpGH/BykXYySHkW6jg=";
          presharedKeyFile = config.age.secrets.zeus_wg0_preshared_key.path;
          allowedIPs = [
            "10.8.0.0/24"
            "fd47:4161:82f9::/64"
            "10.0.0.0/24"
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
    tlp.enable = true; # TLP power scaling
    zfs.autoScrub.enable = true; # Run ZFS scrubs automatically
    fprintd.enable = true; # Fingerprint demon
  };

  ## Custon Services
  custom = {
    blocky.enable = true;
    chrony.enable = true;
  };

  ## Systemd services
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  ### Power management
  powerManagement.enable = true;

  ### Users
  users.users.tibs = {
    extraGroups = [ "video" ];
    shell = pkgs.fish;
  };

  ### Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    nerdfonts
  ];

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "24.05";
  # ======================== DO NOT CHANGE THIS ========================
}
