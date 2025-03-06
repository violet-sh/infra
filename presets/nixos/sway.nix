{ pkgs, ... }:
{
  programs = {
    light.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [ thunar-archive-plugin ];
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
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd sway";
          user = "greeter";
        };
      };
    };
  };

  security.pam.services.swaylock = { };
}
