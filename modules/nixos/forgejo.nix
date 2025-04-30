{ config, lib, ... }:
let
  cfg = config.modules.forgejo;
in
{
  options.modules.forgejo = with lib; {
    enable = mkEnableOption { description = "Enable Forgejo"; };
    hostname = mkOption { type = types.str; };
    port = mkOption { type = types.port; };
  };

  config = lib.mkIf cfg.enable {
    services.forgejo = {
      enable = true;
      settings.server.HTTP_PORT = cfg.port;
    };

    modules.caddy.services.forgejo = {
      hostname = cfg.hostna1me;
      port = cfg.port;
    };
  };
}
