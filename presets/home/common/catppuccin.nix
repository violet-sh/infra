{ lib, pkgs, desktop, ... }:
{
  catppuccin = {
    enable = true;
    accent = "lavender";
    flavor = "macchiato";

    cursors.enable = lib.mkIf desktop true;

  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-GTK-Dark";
      package = pkgs.magnetic-catppuccin-gtk;
    };
  };

  qt = lib.mkIf desktop {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
}
