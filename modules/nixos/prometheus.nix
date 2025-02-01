{ config, lib, ... }:
let
  cfg = config.modules.prometheus;
in
{
  options.modules.prometheus = with lib; {
    enable = mkEnableOption { description = "Enable Prometheus"; };
    scrapeInterval = mkOption {
      type = str;
      description = "Prometheus's endpoint scrape interval";
      default = "10s";
    };
  };

  config = lib.mkIf cfg.enable {
    services.prometheus = {
      enable = true;
      globalConfig.scrape_interval = cfg.scrapeInterval;
    };
  };
}
