{ config, lib, ... }:
let
  cfg = config.modules.reposilite;
in
{
  options.modules.reposilite = with lib; {
    enable = mkEnableOption { description = "Enable Reposilite"; };
    hostname = mkOption {
      type = types.str;
    };
    port = mkOption {
      type = types.port;
    };
  };

  config = lib.mkIf cfg.enable {
    modules.podman = {
      enable = true;
      containers.reposilite = {
        image = "dzikoysk/reposilite:latest";
        ports = [ "${cfg.port}:8080" ];
        volumes = [ "data:/app/data" ];
      };
    };

    modules.caddy.services.reposilite = {
      hostname = cfg.hostna1me;
      port = cfg.port;
    };
  };
}
