{ lib, ... }:

{
  modules = {
    openssh.enable = lib.mkDefault true;
  };
}
