{ pkgs, ... }:
{
  programs = {
    xfconf.enable = true;

    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-vcs-plugin
        thunar-volman
      ];
    };
  };

  services = {
    blueman.enable = true; # Bluetooth manager
    libinput.enable = true;

    gvfs.enable = true; # Mount, trash, etc for Thunar
    tumbler.enable = true; # Thumbnails for Thunar

    # Display manager
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet";
          user = "greeter";
        };
      };
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
