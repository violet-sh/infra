{ ... }:
{
  modules.caddy = {
    enable = true;
    metrics = true;
    configFile = ./Caddyfile;
  };
}
