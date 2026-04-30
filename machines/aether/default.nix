{ config, ... }:
{
  # Module imports
  imports = [
    ./hardware-configuration.nix

    ../../presets/nixos/server.nix
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
    useNetworkd = true;
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

  services = {
    prometheus.exporters = {
      chrony.enable = true;
      wireguard.enable = true;

      node = {
        enable = true;
        enabledCollectors = [
          "ethtool"
          "logind"
          "network_route"
          "systemd"
        ];
      };
    };

    victoriametrics = {
      enable = true;
      prometheusConfig = {
        global = {
          scrape_interval = "10s";
        };
        scrape_configs = [
          {
            job_name = "blocky";
            static_configs = [
              { targets = [ "localhost:${toString config.modules.blocky.ports.http}" ]; }
            ];
          }
          {
            job_name = "chrony";
            static_configs = [
              { targets = [ "localhost:${toString config.services.prometheus.exporters.chrony.port}" ]; }
            ];
          }
          {
            job_name = "forgejo";
            static_configs = [
              { targets = [ "localhost:${toString config.modules.forgejo.port}" ]; }
            ];
          }
          {
            job_name = "node";
            static_configs = [
              { targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ]; }
            ];
          }
          {
            job_name = "wireguard";
            static_configs = [
              { targets = [ "localhost:${toString config.services.prometheus.exporters.wireguard.port}" ]; }
            ];
          }
          {
            job_name = "victoriametrics";
            static_configs = [
              { targets = [ "localhost${toString config.services.victoriametrics.listenAddress}" ]; }
            ];
          }
          {
            job_name = "woodpecker";
            bearer_token_file = config.age.secrets.woodpecker_metrics_token.path;
            static_configs = [
              { targets = [ "localhost:${toString config.modules.woodpecker-server.port}" ]; }
            ];
          }
        ];
      };
    };
  };

  modules = {
    blocky = {
      metrics = true;
      ports.http = [ 2100 ];
    };

    caddy = {
      enable = true;
      metrics = true;
      openFirewall = true;
      extraConfig = ''
        :443 {
          respond "Violet ~ Aether"
        }
      '';
    };

    podman = {
      enable = true;
    };

    wireguard = {
      enable = true;
      ips = [
        "10.8.0.1/16"
        "fd47:4161:82f9::1/64"
      ];
      privateKeyFile = config.age.secrets.aether_wg0_key.path;
      openFirewall = true;
    };

    ### Web services
    grafana = {
      enable = true;
      hostname = "metrics.violet.sh";
      port = 2000;
    };

    forgejo = {
      enable = true;
      hostname = "git.violet.sh";
      port = 2001;
      ssh_port = 2222;
      metrics = true;
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
    #   wings_addr = "hestia:2000";
    # };

    woodpecker-server = {
      enable = true;
      hostname = "ci.violet.sh";
      port = 2004;
      grpcPort = 2005;
      orgs = [ "community-tbd" ];
      admin = [ "violet-sh" ];
      metrics = true;
    };

    woodpecker-agent = {
      enable = true;
    };

    # mycorrhiza = {
    #   enable = true;
    #   hostname = "wiki.violet.sh";
    #   port = 2006;
    # };

    # vencloud = {
    #   enable = true;
    #   hostname = "vencord.violet.sh";
    #   port = 2007;
    # };
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "25.05";
  # ======================== DO NOT CHANGE THIS ========================
}
