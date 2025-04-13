{ pkgs, ... }:
{
  imports = [ ./desktop.nix ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  networking.networkmanager.wifi.powersave = true;

  services = {
    usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };
  };

  environment.systemPackages = with pkgs; [
    batmon
    libimobiledevice
  ];
}
