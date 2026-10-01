{ lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
    "virtio_blk"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/81255a75-e5f5-45d7-9ae7-80251e186e35";
    fsType = "ext4";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/63b7263a-5bc2-4e2b-b3db-21dc73b04ec7"; } ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
