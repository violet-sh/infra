{ config, lib, ... }:
let
  cfg = config.modules.woodpecker-server;
in
{
  options.modules.woodpecker-server = with lib; {
    enable = mkEnableOption { description = "Enable the Woodpecker server"; };
    hostname = mkOption { type = types.str; };
    port = mkOption { type = types.port; };
    orgs = mkOption {
      type = with types; mkList str;
      description = "A list of GitHub orgs allowed to log in";
      default = [ ];
    };
    admin = mkOption {
      type = with types; mkList str;
      description = "A list of admins";
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    services.woodpecker-server = {
      enable = true;
      environment = with lib.strings; {
        WOODPECKER_OPEN = "true";
        WOODPECKER_ORGS = concatStringsSep "," cfg.orgs;
        WOODPECKER_ADMIN = concatStingsSep "," cfg.admin;
        WOODPECKER_HOST = cfg.hostname;
        WOODPECKER_SERVER_ADDR = cfg.port;
        WOODPECKER_GITHUB = "true";
        WOODPECKER_GITHUB_CLIENT_FILE = config.age.secrets.woodpecker_github_client.path;
        WOODPECKER_GITHUB_SECRET_FILE = config.age.secrets.woodpecker_github_secret.path;
        WOODPECKER_AGENT_SECRET_FILE = config.age.secrets.woodpecker_agent_secret.path;
      };
    };

    modules.caddy.services = lib.mkIf config.modules.caddy.enable [
      {
        hostname = cfg.hostname;
        port = cfg.port;
      }
    ];

    # Load in age secrets
    age.secrets = {
      woodpecker_github_client.file = ../../../secrets/woodpecker_github_client.age;
      woodpecker_github_secret.file = ../../../secrets/woodpecker_github_secret.age;
      woodpecker_agent_secret.file = ../../../secrets/woodpecker_agent_secret.age;
    };
  };
}
