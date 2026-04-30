{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.grafana;
in
{
  options.modules.grafana = with lib; {
    enable = mkEnableOption { description = "Enable Grafana"; };
    hostname = mkOption { type = types.str; };
    port = mkOption { type = types.port; };
  };

  config = lib.mkIf cfg.enable {
    age.secrets = {
      grafana_secret_key = {
        file = ../../secrets/grafana_secret_key.age;
        owner = "grafana";
        group = "users";
        mode = "400";
      };
    };

    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_port = cfg.port;
          domain = cfg.hostname;
          enforce_domain = true;
          enable_gzip = true;
        };
        security.secret_key = "$__file{${config.age.secrets.grafana_secret_key.path}}";
        analytics.reporting_enabled = false;
      };

      declarativePlugins = with pkgs.grafanaPlugins; [
        grafana-metricsdrilldown-app
        victoriametrics-metrics-datasource
      ];

      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "VictoriaMetrics";
            type = "victoriametrics-metrics-datasource";
            url = "http://localhost${config.services.victoriametrics.listenAddress}";
            isDefault = true;
            editable = false;
          }
        ];
      };
    };

    modules.caddy.services.grafana = {
      hostname = cfg.hostname;
      port = cfg.port;
    };
  };
}
