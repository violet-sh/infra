{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.modules.home-manager;
in
{
  options.modules.home-manager = with lib; {
    enable = mkEnableOption { description = "Enable Home Manager"; };
    desktop = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs =
        let
          age = config.age;
          desktop = cfg.desktop;
        in
        {
          inherit age inputs desktop;
        };
      users.tibs =
        {  desktop, ... }:
        {
          imports =
            if desktop then
              [ ../../presets/home ../../presets/home/desktop ]
            else
              [ ../../presets/home ];
        };
    };
  };
}
