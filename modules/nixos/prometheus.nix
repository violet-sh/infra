{ config, lib, ... }:
let
  cfg = config.modules.prometheus;
in
{
  options.modules.prometheus = with lib; {
    enable = mkEnableOption { description = "Enable Prometheus"; };
    scrapeInterval = mkOption {
      type = types.str;
      description = "Prometheus's endpoint scrape interval";
      default = "10s";
    };
    exporters = mkOption {
      type =
        with types;
        submodule {
          options = {
            node = mkOption {
              type = submodule {
                options = {
                  enable = mkEnableOption { description = "Enable Node exporter"; };
                  enabledCollectors = mkOption {
                    type = listOf str;
                    description = "List of collectors to enable.";
                    default = [ "systemd" ];
                  };
                };
              };
            };
          };
        };
    };
  };

  config = lib.mkIf cfg.enable {
    services.prometheus = {
      enable = true;
      globalConfig.scrape_interval = cfg.scrapeInterval;
      exporters = cfg.exporters;
      scrapeConfigs =
        let
          exporter_list = lib.attrsToList cfg.exporters;
          enabled_exporters = builtins.filter (exporter: exporter.value.enable) exporter_list;
          configs = map (exporter: {
            job_name = exporter.name;
            static_configs = [
              {
                targets = [ "localhost:${toString config.services.prometheus.exporters."${exporter.name}".port}" ];
              }
            ];
          }) enabled_exporters;
        in
        configs;
    };
  };
}
