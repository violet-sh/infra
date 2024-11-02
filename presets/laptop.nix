{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    batmon
  ];
}
