{ config, lib, ... }:
let
  cfg = config.modules.chrony;
in
{
  options.modules.chrony = with lib; {
    enable = mkEnableOption { description = "Enable Chrony"; };
    servers = mkOption {
      type = with types; listOf str;
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
