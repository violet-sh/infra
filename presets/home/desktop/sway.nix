{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    grim
    playerctl
    slurp
    wayland-pipewire-idle-inhibit
    wayland-scanner
    wl-clipboard
    wl-clip-persist
  ];

  programs = {
    swaylock.enable = true;
    tofi.enable = true;
  };

  services = {
    avizo.enable = true;
    blueman-applet.enable = true;
    network-manager-applet.enable = true;

    swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.playerctl}/bin/playerctl pause";
        }
        {
          event = "before-sleep";
          command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
        }
        {
          event = "after-resume";
          command = "${pkgs.swayfx}/bin/swaymsg 'output * power on'";
        }
      ];
      timeouts = [
        {
          timeout = 300;
          command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
        }
        {
          timeout = 600;
          command = "${pkgs.swayfx}/bin/swaymsg 'output * power off'";
        }
      ];
    };

    swaync = {
      enable = true;
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    swaynag.enable = true;
    wrapperFeatures.gtk = true;

    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "tofi-drun | xargs swaymsg exec --";

      output = {
        "*".bg = "~/Pictures/wallpapers/arcanepigeon/mushroom.png fill";
        eDP-1 = {
          scale = "1";
          pos = "0,0";
        };
        DP-2.pos = "1504,0";
      };

      input."type:touchpad" = {
        tap = "enabled";
        click_method = "clickfinger";
        natural_scroll = "enabled";
        dwt = "disabled";
      };

      input."type:pointer" = {
        natural_scroll = "enabled";
        dwt = "disabled";
      };

      defaultWorkspace = "workspace number 1";

      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          XF86AudioRaiseVolume = "exec volumectl -u up";
          XF86AudioLowerVolume = "exec volumectl -u down";
          XF86AudioMute = "exec volumectl toggle-mute";

          XF86AudioPrev = "exec playerctl previous";
          XF86AudioNext = "exec playerctl next";
          XF86AudioPlay = "exec playerctl play-pause";

          XF86MonBrightnessUp = "exec lightctl up";
          XF86MonBrightnessDown = "exec lightctl down";

          "${modifier}+Shift+n" = "exec swaync-client -t -sw";
          "${modifier}+Print" = ''exec grim -g "$(slurp)" - | wl-copy'';
          "${modifier}+Shift+Print" =
            ''exec grim -g "$(slurp)" $HOME/Pictures/Screenshots/$(date +%F\_%H.%M.%S).png'';

          "${modifier}+b" = "exec firefox";
          "${modifier}+Shift+b" = "exec firefox --private-window";
        };

      window.commands = [
        {
          command = "inhibit_idle fullscreen";
          criteria = {
            app_id = "^.*";
          };
        }
      ];

      floating = {
        criteria = [
          {
            app_id = "Firefox";
            title = "Extension:.*";
          }
        ];
      };

      bars = [ ];

      gaps.inner = 10;

      startup = [
        { command = "avizo-service"; }
        { command = "blueman-applet"; }
        { command = "nm-applet"; }
        { command = "swaync"; }
        { command = "wayland-pipewire-idle-inhibit"; }
        { command = "wl-clip-persist --clipboard regular"; }
      ];
    };

    extraConfig = ''
      default_border none
      default_floating_border none

      corner_radius 10

      blur enable
      blur_xray disable
      blur_passes 1
      blur_radius 4

      shadows enable
      shadows_on_csd disable
      shadow_blur_radius 20
      shadow_color #0000006F

      default_dim_inactive 0.0
      dim_inactive_colors.unfocused #000001FF
      dim_inactive_colors.urgent #899999FF

      scratchpad_minimize disable
    '';

    checkConfig = false; # https://github.com/nix-community/home-manager/issues/5379
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdk-desktop-portal-wlr ];
  };
}
