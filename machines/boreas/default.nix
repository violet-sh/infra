{
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

  networking = {
    hostName = "boreas";
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "26.05";
  # ======================== DO NOT CHANGE THIS ========================
}
