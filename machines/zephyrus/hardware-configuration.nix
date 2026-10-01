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
    device = "/dev/disk/by-uuid/55ec7dfe-d2c8-42ed-9224-a8a302f66859";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6152-4185";
    fsType = "vfat";
    options = [
      "dmask=0077"
      "fmask=0077"
    ];
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/a4293321-cb38-4464-9e3f-55df2c6b462a"; } ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
