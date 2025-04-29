{ config, pkgs, ... }:
{
  # Module imports
  imports = [
    # ./hardware-configuration.nix
  ];

  age.secrets = {
    aether_wg0_key.file = ../../secrets/aether_wg0_key.age;
  };

  modules = {
    wireguard = {
      enable = true;
      ips = [
        "10.8.0.1/16"
        "fd47:4161:82f9::1/64"
      ];
      privateKeyFile = config.age.secrets.aether_wg0_key.path;
    };

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
