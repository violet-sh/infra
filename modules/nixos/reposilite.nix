{ config, lib, ... }:
let
  cfg = config.modules.reposilite;
in
{
  options.modules.reposilite = with lib; {
    enable = mkEnableOption { description = "Enable Reposilite"; };
    hostname = mkOption { type = types.str; };
    port = mkOption { type = types.port; };
  };

  config = lib.mkIf cfg.enable {
    services.reposilite = {
      enable = true;
      settings.port = cfg.port;
    };

    modules.caddy.services.reposilite = {
      hostname = cfg.hostname;
      port = cfg.port;
    };
  };
}
