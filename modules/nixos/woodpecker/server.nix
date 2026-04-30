{ config, lib, ... }:
let
  cfg = config.modules.woodpecker-server;
in
{
  options.modules.woodpecker-server = with lib; {
    enable = mkEnableOption { description = "Enable the Woodpecker server"; };
    hostname = mkOption { type = types.str; };
    port = mkOption { type = types.port; };
    grpcPort = mkOption { type = types.port; };
    orgs = mkOption {
      type = with types; listOf str;
      description = "A list of GitHub orgs allowed to log in";
      default = [ ];
    };
    admin = mkOption {
      type = with types; listOf str;
      description = "A list of admins";
      default = [ ];
    };
    metrics = mkOption {
      type = types.bool;
      description = "Whether to enable Prometheus metrics for Woodpecker";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.woodpecker-server = {
      enable = true;
      environment = {
        WOODPECKER_OPEN = "true";
        WOODPECKER_ORGS = builtins.concatStringsSep "," cfg.orgs;
        WOODPECKER_ADMIN = builtins.concatStringsSep "," cfg.admin;
        WOODPECKER_HOST = "https://${cfg.hostname}";
        WOODPECKER_SERVER_ADDR = ":${toString cfg.port}";
        WOODPECKER_GRPC_ADDR = ":${toString cfg.grpcPort}";
        WOODPECKER_GITHUB = "true";
        WOODPECKER_GITHUB_CLIENT_FILE = config.age.secrets.woodpecker_github_client.path;
        WOODPECKER_GITHUB_SECRET_FILE = config.age.secrets.woodpecker_github_secret.path;
        WOODPECKER_AGENT_SECRET_FILE = config.age.secrets.woodpecker_agent_secret.path;
        WOODPECKER_PROMETHEUS_AUTH_TOKEN_FILE = lib.mkIf cfg.metrics config.age.secrets.woodpecker_metrics_token.path;
      };
    };

    modules.caddy.services.woodpecker-server = lib.mkIf config.modules.caddy.enable {
      hostname = cfg.hostname;
      port = cfg.port;
    };

    # Load in age secrets
    # Can't set file user to dynamic user (woodpecker), so 644 will suffice
    age.secrets = {
      woodpecker_github_client = {
        file = ../../../secrets/woodpecker_github_client.age;
        mode = "644";
      };
      woodpecker_github_secret = {
        file = ../../../secrets/woodpecker_github_secret.age;
        mode = "644";
      };
      woodpecker_agent_secret = {
        file = ../../../secrets/woodpecker_agent_secret.age;
        mode = "644";
      };
      woodpecker_metrics_token = {
        file = ../../../secrets/woodpecker_metrics_token.age;
        mode = "644";
      };
    };
  };
}
