{ pkgs, ... }:
{
  sparrow-wifi = pkgs.callPackage ./sparrow-wifi.nix { };
}
