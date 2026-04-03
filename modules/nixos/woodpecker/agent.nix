{ config, lib, ... }:
let
  cfg = config.modules.woodpecker-agent;
in
{
  options.modules.woodpecker-agent = with lib; {
    enable = mkEnableOption { description = "Enable the Woodpecker agent"; };
    server_addr = mkOption {
      type = types.str;
      default = "localhost:${toString config.modules.woodpecker-server.grpcPort}";
    };
  };

  config = lib.mkIf cfg.enable {
    services.woodpecker-agents.agents = {
      podman = {
        enable = true;
        extraGroups = [ "podman" ];
        environment = {
          WOODPECKER_SERVER = cfg.server_addr;
          WOODPECKER_BACKEND = "docker";
          DOCKER_HOST = "unix:///run/podman/podman.sock";
          WOODPECKER_AGENT_SECRET_FILE = config.age.secrets.woodpecker_agent_secret.path;
        };
      };
    };

    age.secrets = {
      woodpecker_agent_secret = {
        file = ../../../secrets/woodpecker_agent_secret.age;
        mode = "644";
      };
    };
  };
}
