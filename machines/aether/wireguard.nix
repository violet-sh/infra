{ config, ... }:

{
  # Load secrets
  age.secrets = {
    aether_wg0_key.file = ../../secrets/aether_wg0_key.age;
    zeus_wg0_preshared_key.file = ../../secrets/zeus_wg0_preshared_key.age;
    atlas_wg0_preshared_key.file = ../../secrets/atlas_wg0_preshared_key.age;
    apollo_wg0_preshared_key.file = ../../secrets/apollo_wg0_preshared_key.age;
    hermes_wg0_preshared_key.file = ../../secrets/hermes_wg0_preshared_key.age;
  };

  networking.wireguard.interfaces.wg0 = {
    ips = [
      "10.8.0.1/24"
      "10.0.0.16/24"
      "fd47:4161:82f9::1/64"
    ];
    privateKeyFile = config.age.secrets.aether_wg0_key.path;
    peers = [
      {
        # Atlas
        publicKey = "KILRF/mGDBpf7xOWJg+vsewIoIFsiEXsHoB8MJsK3T8=";
        presharedKeyFile = config.age.secrets.atlas_wg0_preshared_key.path;
        allowedIPs = [
          "10.8.0.2/32"
          "fd47:4161:82f9::2/128"
        ];
      }
      {
        # Zeus
        publicKey = "6ZEA+gRxXflZWLOHy8epyKCBAunwuwt9SU6R5Nbvbys=";
        presharedKeyFile = config.age.secrets.zeus_wg0_preshared_key.path;
        allowedIPs = [
          "10.8.0.3/32"
          "fd47:4161:82f9::3/128"
        ];
      }
      {
        # Hermes
        publicKey = "DFHeIKM03pv3mlDefk7HgIpyJN4ZeYJcTjfaYIPM6gU=";
        presharedKeyFile = config.age.secrets.hermes_wg0_preshared_key.path;
        allowedIPs = [
          "10.8.0.4/32"
          "fd47:4161:82f9::4/128"
        ];
      }
      {
        # Apollo
        publicKey = "NW41EykKyE1oJRHBhSh0OeqH6IKpEPAwrHVV6SByJ1A=";
        presharedKeyFile = config.age.secrets.apollo_wg0_preshared_key.path;
        allowedIPs = [
          "10.8.0.5/32"
          "fd47:4161:82f9::5/128"
        ];
      }
      {
        # April
        publicKey = "y9kGzabssHfPH18xlPFFnSCoyStXnEihmecFEv0Fklg=";
        allowedIPs = [
          "10.8.0.7/32"
          "10.0.0.0/24"
        ];
        endpoint = "23.88.37.55:59234";
        persistentKeepalive = 25;
      }
      {
        # Octal
        publicKey = "V70/5WUeOYVefNob9/PbhSt9InGfVCnwCiSkakwAFyA=";
        allowedIPs = [
          "10.8.0.8/32"
        ];
      }
    ];
  };
}
