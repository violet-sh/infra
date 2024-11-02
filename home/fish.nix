{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    plugins = with pkgs.fishPlugins; [
      {
        name = "autopair";
        src = autopair.src;
      }
      {
        name = "colored-man-pages";
        src = colored-man-pages.src;
      }
      {
        name = "done";
        src = done.src;
      }
      {
        name = "grc";
        src = grc.src;
      }
      {
        name = "fifc";
        src = fifc.src;
      }
      {
        name = "forgit";
        src = forgit.src;
      }
      {
        name = "fzf-fish";
        src = fzf-fish.src;
      }
      {
        name = "sponge";
        src = sponge;
      }
    ];
  };
}
