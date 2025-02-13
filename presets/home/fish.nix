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
        name = "grc";
        src = grc.src;
      }
      {
        name = "fifc";
        src = fifc.src;
      }
      {
        name = "fish-bd";
        src = fish-bd.src;
      }
      {
        name = "fish-you-should-use";
        src = fish-you-should-use.src;
      }
      {
        name = "puffer";
        src = puffer.src;
      }
      {
        name = "sponge";
        src = sponge.src;
      }
      {
        name = "z";
        src = z.src;
      }
    ];
  };
}
