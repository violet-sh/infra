{ config, ... }:
{
  # Module imports
  imports = [
    ./hardware-configuration.nix

    ../../presets/nixos/server.nix

    ./caddy.nix
  ];

  boot = {
    loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      mirroredBoots = [
        {
          devices = [ "nodev" ];
          path = "/boot";
        }
      ];
    };

    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
      "net.ipv6.conf.all.accept_ra" = 0;
    };
  };

  age.secrets = {
    aether_wg0_key.file = ../../secrets/aether_wg0_key.age;
  };

  networking = {
    hostName = "aether";
    hostId = "ff85a7eb";
    interfaces.ens3 = {
      ipv4.addresses = [
        {
          address = "162.120.71.136";
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          address = "2a0a:8dc0:2000:97::2";
          prefixLength = 126;
        }
      ];
    };

    defaultGateway = {
      address = "162.120.71.1";
      interface = "ens3";
    };
    defaultGateway6 = {
      address = "2a0a:8dc0:2000:97::1";
      interface = "ens3";
    };
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

    ### Web services
    forgejo = {
      enable = true;
      hostname = "git.violet.sh";
      port = 2001;
    };

    reposilite = {
      enable = true;
      hostname = "maven.violet.sh";
      port = 2002;
    };

    # pelican = {
    #   enable = true;
    #   hostname = "panel.violet.sh";
    #   port = 2003;
    #   wings_port = 2004;
    # };

    woodpecker-server = {
      enable = true;
      hostname = "ci.violet.sh";
      port = 2005;
      orgs = [ "community-tbd" ];
      admin = [ "TibiNonEst" ];
    };

    # mycorrhiza = {
    #   enable = true;
    #   hostname = "wiki.violet.sh";
    #   port = 2006;
    # };

    sftpgo = {
      enable = true;
      hostname = "vault.violet.sh";
      port = 2007;
      sftp_port = 2122;
    };

    # vencloud = {
    #   enable = true;
    #   hostname = "vencord.violet.sh";
    #   port = 2008;
    # };

    # jellyfin = {
    #   enable = true;
    #   hostname = "watch.violet.sh";
    #   port = 2009;
    # };

    # grafana = {
    #   enable = true;
    #   hostname = "metrics.violet.sh";
    #   port = 2010;
    # };
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "25.05";
  # ======================== DO NOT CHANGE THIS ========================
}
