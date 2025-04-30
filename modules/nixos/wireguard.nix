{ config, lib, ... }:
let
  cfg = config.modules.wireguard;
  hostname = config.networking.hostName;
in
{
  options.modules.wireguard = with lib; {
    enable = mkEnableOption { description = "Enable Wireguard"; };
    ips = mkOption { type = with types; listOf str; };
    port = mkOption {
      type = types.port;
      default = 51820;
    };
    interfaceName = mkOption {
      type = types.str;
      default = "wg0";
    };
    privateKey = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    privateKeyFile = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    mesh = mkOption {
      type =
        with types;
        submodule {
          options = {
            enable = mkEnableOption { description = "Enable meshing with wgautomesh"; };
            gossipSecretFile = mkOption {
              type = path;
            };
          };
        };
      default = {
        enable = true;
      };
    };
    peers = mkOption {
      type =
        with types;
        listOf (submodule {
          options = rec {
            name = mkOption {
              type = str;
              default = publicKey;
            };
            publicKey = mkOption {
              type = str;
            };
            presharedKey = mkOption {
              type = nullOr str;
              default = null;
            };
            presharedKeyFile = mkOption {
              type = nullOr str;
              default = null;
            };
            allowedIPs = mkOption {
              type = listOf str;
              default = [ ];
            };
            endpoint = mkOption {
              type = nullOr str;
              default = null;
            };
            persistentKeepalive = mkOption {
              type = nullOr int;
              default = null;
            };
            mesh = mkOption {
              type =
                with types;
                submodule {
                  options = {
                    enable = mkEnableOption { description = "Enable meshing with wgautomesh"; };
                    ip = mkOption {
                      type = string;
                      # default = builtins.head (lib.splitString "/" (builtins.head allowedIPs)); # Can't self reference in a rec for options?
                    };
                  };
                };
              default = { };
            };
          };
        });
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      wireguard.interfaces.${cfg.interfaceName} = {
        ips = cfg.ips;
        privateKey = cfg.privateKey;
        privateKeyFile = cfg.privateKeyFile;
        listenPort = cfg.port;
        peers =
          let
            filtered_peers = builtins.filter (peer: hostname == "aether" || peer.name == "aether") cfg.peers; # Distribute peers in hub to begin with
            peers = builtins.map (peer: builtins.removeAttrs peer [ "mesh" ]) filtered_peers;
          in
          peers;
      };

      firewall.trustedInterfaces = [ (cfg.interfaceName) ];
      search = [ "wg" ];
    };

    services.wgautomesh = lib.mkIf cfg.mesh.enable {
      enable = true;
      gossipSecretFile = cfg.mesh.gossipSecretFile;
      settings = {
        interface = cfg.interfaceName;
        peers =
          let
            peers = builtins.map (peer: {
              pubkey = peer.publicKey;
              endpoint = peer.endpoint;
              address = peer.mesh.ip;
            }) (builtins.filter (peer: peer.mesh.enable) cfg.peers);
          in
          peers;
      };
    };
  };
}
