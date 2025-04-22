{ ... }:
{
  catppuccin = {
    enable = true;
    accent = "lavender";
    flavor = "macchiato";

    cursors.enable = true;

    gtk = {
      enable = true;
      gnomeShellTheme = true;
    };
  };

  gtk.enable = true;

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
}
