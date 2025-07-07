{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.caddy;
in
{
  options.modules.caddy = with lib; {
    enable = mkEnableOption { description = "Enable Caddy"; };
    services = mkOption {
      type =
        with types;
        listOf (submodule {
          hostname = mkOption {
            type = str;
            description = "The hostname of this virtual host";
          };
          serverAliases = mkOption {
            type = listOf str;
            description = "Additional hostnames for this virtual host to respond to";
            default = [ ];
          };
          address = mkOption {
            type = str;
            description = "The address of the service to reverse proxy";
            default = "127.0.0.1";
          };
          port = mkOption {
            type = port;
            description = "The port of the service to reverse proxy";
          };
          dnsProvider = mkOption {
            type = str;
            descrption = "The DNS provider to use for this virtual host (cloudflare | bunny)";
            default = "bunny";
          };
        });
      description = "Service configurations for reverse proxy virtual hosts";
      default = [ ];
    };
    metrics = mkOption {
      type = types.bool;
      description = "Whether to enable metrics on Caddy";
      default = false;
    };
    configFile = mkOption {
      type = types.path;
      description = "Path to Caddyfile";
    };
    extraConfig = mkOption {
      type = types.lines;
      description = "Extra config to add to the created Caddyfile";
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [
          "github.com/caddy-dns/bunny@v1.2.0"
          "github.com/caddy-dns/cloudflare@v0.2.1"
        ];
        hash = "sha256-uilJaEJVzKylNcCB4bKGr+65NkPMHpB0WS1qX6ue7S0=";
      };
      globalConfig = lib.mkIf cfg.metrics ''
        {
          servers {
            metrics
          }
        }
      '';
      configFile = cfg.configFile;
      extraConfig = cfg.extraConfig;
      environmentFile = config.age.secrets.caddy_env.path;
    };

    # Load in age secrets
    age.secrets = {
      # bunny_tls_api_key.file = ../../secrets/bunny_tls_api_key.age;
      # cloudflare_tls_api_key.file = ../../secrets/cloudflare_tls_api_key.age;
      caddy_env.file = ../../secrets/caddy_env.age;
    };
  };
}
