{ config, lib, ... }:
let
  cfg = config.custom.chrony;
in
{
  options.custom.chrony = with lib; {
    enable = mkEnableOption { description = "Enable Chrony"; };
    servers = mkOption {
      type = types.listOf types.str;
      description = "List of servers for Chrony";
      default = [
        "pool.ntp.org"
        "clock.he.net"
        "time.nist.gov"
        "time.cloudflare.com"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    services.chrony = {
      enable = true;
      servers = cfg.servers;
    };
  };
}
