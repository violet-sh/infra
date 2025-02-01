{ config, lib, ... }:
let
  cfg = config.modules.openssh;
in
{
  options.modules.openssh = with lib; {
    enable = mkEnableOption { description = "Enable Openssh"; };
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };
}
