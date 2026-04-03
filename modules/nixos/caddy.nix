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
        attrsOf (submodule {
          options = {
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
              description = "The DNS provider to use for this virtual host (cloudflare | bunny)";
              default = "bunny";
            };
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
      type = with types; nullOr path;
      description = "Path to Caddyfile";
      default = null;
    };
    extraConfig = mkOption {
      type = types.lines;
      description = "Extra config to add to the created Caddyfile";
      default = "";
    };
    openFirewall = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [
          "github.com/caddy-dns/bunny@v1.2.0"
          "github.com/caddy-dns/cloudflare@v0.2.3"
        ];
        hash = "sha256-wGWoE7j2rt4V5+hm3rYSvSzY6J9goZuq1og964Dygmg=";
      };
      globalConfig = lib.mkIf cfg.metrics ''
        metrics {
          per_host
        }
      '';
      virtualHosts =
        let
          services = builtins.mapAttrs (name: value: {
            hostName = value.hostname;
            serverAliases = value.serverAliases;
            extraConfig = ''
              import ${value.dnsProvider}
              reverse_proxy ${value.address}:${toString value.port}
            '';
          }) cfg.services;
        in
        services;
      configFile = lib.mkIf (cfg.configFile != null) cfg.configFile;
      extraConfig =
        let
          tls = ''
            (bunny) {
            	tls {
            		dns bunny {$BUNNY_API_KEY}
            	}
            }
            (cloudflare) {
            	tls {
            		dns cloudflare {$CLOUDFLARE_API_KEY}
            	}
            }
          '';
        in
        cfg.extraConfig + tls;
      environmentFile = config.age.secrets.caddy_env.path;
    };

    modules.prometheus.scrapeConfigs = lib.mkIf cfg.metrics [
      {
        job_name = "caddy";
        static_configs = [
          { targets = [ "localhost:2019" ]; }
        ];
      }
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      80
      443
    ];

    # Load in age secrets
    age.secrets = {
      # bunny_tls_api_key.file = ../../secrets/bunny_tls_api_key.age;
      # cloudflare_tls_api_key.file = ../../secrets/cloudflare_tls_api_key.age;
      caddy_env.file = ../../secrets/caddy_env.age;
    };
  };
}
