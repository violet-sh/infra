{ config, lib, ... }:
let
  cfg = config.modules.forgejo;
in
{
  options.modules.forgejo = with lib; {
    enable = mkEnableOption { description = "Enable Forgejo"; };
    hostname = mkOption { type = types.str; };
    port = mkOption { type = types.port; };
    ssh_port = mkOption { type = types.port; };
    lfs = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services.forgejo = {
      enable = true;
      lfs.enable = cfg.lfs;
      settings = {
        DEFAULT = {
          APP_NAME = "violet's git";
        };
        server = {
          DOMAIN = cfg.hostname;
          HTTP_PORT = cfg.port;
          PROTOCOL = "https";
          ROOT_URL = "https://${cfg.hostname}/";
          SSH_PORT = cfg.ssh_port;
        };
        security = {
          PASSWORD_HASH_ALGO = "argon2";
        };
        ui = {
          DEFAULT_THEME = "catppuccin-macchiato-lavender";
        };
      };
    };

    modules.caddy.services.forgejo = {
      hostname = cfg.hostname;
      port = cfg.port;
    };
  };
}
