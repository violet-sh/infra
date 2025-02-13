{ config, lib, ... }:
let
  cfg = config.modules.blocky;
in
{
  options.modules.blocky = with lib; {
    enable = mkEnableOption { description = "Enable Blocky"; };
    updateDns = mkOption {
      type = types.bool;
      description = "Update machine local DNS?";
      default = true;
    };
    upstreams = mkOption {
      type = with types; listOf str;
      description = "List of upstreams for Blocky";
      default = [
        "https://ordns.he.net/dns-query"
        "https://dns.quad9.net/dns-query"
        "https://security.cloudflare-dns.com/dns-query"
        "https://base.dns.mullvad.net/dns-query"
        "https://freedns.controld.com/p2"
        "https://dns.adguard-dns.com/dns-query"
      ];
    };
    allowlists = mkOption {
      type = with types; listOf str;
      description = "List of allowlists for Blocky";
      default = [ "*deno.dev" ];
    };
    denylists = mkOption {
      type = with types; listOf str;
      description = "List of denylists for Blocky";
      default = [
        "https://cdn.jsdelivr.net/gh/StevenBlack/hosts@master/alternates/fakenews/hosts"
        "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro.txt"
        "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/tif.txt"
        "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/dyndns.txt"
        "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/hoster.txt"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    networking = lib.mkIf cfg.updateDns {
      networkmanager.dns = "none";
      nameservers = [
        "127.0.0.1"
        "::1"
      ];
    };

    services.blocky = {
      enable = true;
      settings = {
        upstreams.groups.default = cfg.upstreams;
        bootstrapDns = {
          upstream = "https://ordns.he.net/dns-query";
          ips = [
            "74.82.42.42"
            "2001:470:20::2"
          ];
        };
        blocking = {
          allowlists = {
            default = cfg.allowlists;
          };
          denylists = {
            default = cfg.denylists;
          };
          clientGroupsBlock = {
            default = [ "default" ];
          };
        };
        caching.prefetching = true;
        customDNS.mapping = {
          "aether.wg" = "10.8.0.1";
          "atlas.wg" = "10.8.0.2";
          "zeus.wg" = "10.8.0.3";
          "hermes.wg" = "10.8.0.4";
          "apollo.wg" = "10.8.0.5";
        };
      };
    };
  };
}
