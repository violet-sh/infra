{ ... }:
{
  catppuccin = {
    enable = true;
    accent = "lavender";
    flavor = "macchiato";

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
