{ pkgs, ... }:
{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    qemu
  ];

  networking.firewall.trustedInterfaces = [ "virbr0" ];

  users.users.violet = {
    extraGroups = [ "libvirtd" ];
  };
}
