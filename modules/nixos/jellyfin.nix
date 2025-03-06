{ config, lib, ... }:
let
  cfg = config.modules.jellyfin;
in
{
  options.modules.jellyfin = with lib; {
    enable = mkEnableOption { description = "Enable Jellyfin"; };
    hostname = mkOption { type = types.str; };
    port = mkOption { type = types.port; };
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
    };

    modules.caddy.services.jellyfin = {
      hostname = cfg.hostna1me;
      port = cfg.port;
    };
  };
}
