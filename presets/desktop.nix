{ inputs, pkgs, ... }:

{
  imports = [
    ./sway.nix
  ];

  programs = {
    dconf.enable = true;
    fish.enable = true;
    steam.enable = true;

    # GnuPG
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    printing.enable = true; # Cups
    pcscd.enable = true; # Smart card (Yubikey) daemon

    # Sound
    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    # Mullvad VPN
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn; # Use GUI instead of CLI
    };

    udev.packages = [ pkgs.yubikey-personalization ];
  };

  environment.systemPackages = with pkgs; [
    inputs.deploy-rs.packages.x86_64-linux.deploy-rs
    inputs.ragenix.packages.x86_64-linux.default
  ];

  security.polkit.enable = true;
  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ]; # Allow home-manager to manage xdg portals
}
