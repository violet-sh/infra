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
          "github.com/caddy-dns/bunny@v0.1.0"
          "github.com/caddy-dns/cloudflare@89f16b99c18ef49c8bb470a82f895bce01cbaece"
        ];
        hash = lib.fakeHash;
      };
      globalConfig = lib.mkIf cfg.metrics ''
        {
          servers {
            metrics
          }
        }
      '';
      extraConfig = cfg.extraConfig;
    };

    # Load in age secrets
    age.secrets = {
      bunny_tls_api_key.file = ../../secrets/bunny_tls_api_key.age;
      cloudflare_tls_api_key.file = ../../secrets/cloudflare_tls_api_key.age;
    };

    # Load in Caddy secrets
    system.activationScripts."caddy-secrets" = ''
      bunny_tls_api_key=$(cat "${config.age.secrets.bunny_tls_api_key.path}")
      cloudflare_tls_api_key=$(cat "${config.age.secrets.cloudflare_tls_api_key.path}")
      configFile=${config.services.caddy.configFile}
      ${pkgs.gnused}/bin/sed -i "s/@bunny_tls_api_key@/$bunny_tls_api_key/;s/@cloudflare_tls_api_key@/$cloudflare_tls_api_key/" "$configFile"
    '';
  };
}
