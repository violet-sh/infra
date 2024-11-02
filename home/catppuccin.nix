{ ... }:

{
  catppuccin = {
    enable = true;
    accent = "lavender";
    flavor = "macchiato";
  };

  gtk = {
    enable = true;
    catppuccin = {
      enable = true;
      gnomeShellTheme = true;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
      catppuccin.enable = false;
    };
  };
}
