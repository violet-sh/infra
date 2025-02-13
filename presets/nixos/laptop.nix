{ pkgs, ... }:

{
  imports = [
    ./desktop.nix
  ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  powerManagement.enable = true;
  networking.networkmanager.wifi.powersave = true;

  services = {
    tlp.enable = true;

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
