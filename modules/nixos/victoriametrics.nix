{ config, lib, ... }:
let
  cfg = config.modules.victoriametrics;
in
{
  options.modules.victoriametrics = with lib; {
    enable = mkEnableOption { description = "Enable VictoriaMetrics"; };
    scrapeConfigs = mkOption {
      type =
        with types;
        listOf (submodule {
          options = {
            job_name = mkOption {
              type = str;
            };
            static_configs = mkOption {
              type = listOf (submodule {
                options = {
                  targets = mkOption {
                    type = listOf str;
                  };
                };
              });
            };
          };
        });
    };
  };

  config = lib.mkIf cfg.enable {
    services.victoriametrics = {
      enable = true;
      prometheusConfig = {
        scrape_configs =
          let
            exporters = lib.attrsToList config.services.prometheus.exporters;
            enabled_exporters = builtins.filter (exporter: exporter.value.enable) exporters;
            configs = map (exporter: {
              job_name = exporter.name;
              static_configs = [
                {
                  targets = [ "localhost:${toString exporter.port}" ];
                }
              ];
            }) enabled_exporters;
          in
          configs ++ cfg.scrapeConfigs;
      };
    };
  };
}
