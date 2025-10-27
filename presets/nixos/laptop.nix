{ pkgs, ... }:
{
  imports = [ ./desktop.nix ];

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  networking.networkmanager.wifi.powersave = true;

  services = {
    logind = {
      powerKey = "suspend";
    };

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
