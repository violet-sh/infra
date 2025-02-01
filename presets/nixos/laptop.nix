{ pkgs, ... }:

{
  services = {
    tlp.enable = true;

    usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };
  };

  powerManagement.enable = true;
  networking.networkmanager.wifi.powersave = true;

  environment.systemPackages = with pkgs; [
    batmon
    libimobiledevice
    sparrow-wifi
  ];
}
