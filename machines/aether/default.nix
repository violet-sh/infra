{
  config,
  pkgs,
  ...
}:

{
  # Module imports
  imports = [
    # ./hardware-configuration.nix

    ./wireguard.nix
  ];

  modules = {
    caddy = {
      enable = true;
      metrics = true;
    };

    forgejo = {
      enable = true;
      hostname = "git.tibs.gay";
      port = 2000;
    };

    reposilite = {
      enable = true;
      hostname = "maven.tibs.gay";
      port = 3000;
    };

    woodpecker-server = {
      enable = true;
      hostname = "ci.tibs.gay";
      port = 4000;
      orgs = [ "community-tbd" ];
      admin = [ "TibiNonEst" ];
    };
  };
}
