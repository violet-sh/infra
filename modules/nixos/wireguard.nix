{ config, lib, ... }:
let
  cfg = config.modules.wireguard;
  hostname = config.networking.hostName;
in
{
   options.modules.wireguard = with lib; {
    enable = mkEnableOption { description = "Enable Wireguard"; };
    ip = mkOption { type = types.str; };
    port = mkOption { type = types.port; };
  };

  config = lib.mkIf cfg.enable {
    
  };
}
