{ config, ... }:
{
  # Load secrets
  age.secrets = {
    aether_wg0_key.file = ../../secrets/aether_wg0_key.age;
    zeus_wg0_preshared_key.file = ../../secrets/zeus_wg0_preshared_key.age;
    hera_wg0_preshared_key.file = ../../secrets/hera_wg0_preshared_key.age;
    hermes_wg0_preshared_key.file = ../../secrets/hermes_wg0_preshared_key.age;
    hestia_wg0_preshared_key.file = ../../secrets/hestia_wg0_preshared_key.age;
    # athena_wg0_preshared_key.file = ../../secrets/athena_wg0_preshared_key.age;
    # zephyrus_wg0_preshared_key.file = ../../secrets/zephyrus_wg0_preshared_key.age;
    dionysus_wg0_preshared_key.file = ../../secrets/dionysus_wg0_preshared_key.age;
  };

  networking.wireguard.interfaces.wg0 = {
    ips = [
      "10.8.0.1/16"
      "fd47:4161:82f9::1/64"
    ];
    privateKeyFile = config.age.secrets.aether_wg0_key.path;
    peers = [
      {
        # Zeus
        publicKey = "6ZEA+gRxXflZWLOHy8epyKCBAunwuwt9SU6R5Nbvbys=";
        presharedKeyFile = config.age.secrets.zeus_wg0_preshared_key.path;
        allowedIPs = [
          "10.8.0.2/32"
          "fd47:4161:82f9::2/128"
        ];
      }
      {
        # Hera
        publicKey = "KILRF/mGDBpf7xOWJg+vsewIoIFsiEXsHoB8MJsK3T8=";
        presharedKeyFile = config.age.secrets.hera_wg0_preshared_key.path;
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
        # Hestia
        publicKey = "NW41EykKyE1oJRHBhSh0OeqH6IKpEPAwrHVV6SByJ1A=";
        presharedKeyFile = config.age.secrets.hestia_wg0_preshared_key.path;
        allowedIPs = [
          "10.8.0.5/32"
          "fd47:4161:82f9::5/128"
        ];
      }
      # {
      #   # Athena
      #   publicKey = "<pubkey>";
      #   presharedKeyFile = config.age.secrets.athena_wg0_preshared_key.path;
      #   allowedIPs = [
      #     "10.8.0.6/32"
      #     "fd47:4161:82f9::6/128"
      #   ];
      # }
      # {
      #   # Zephyrus
      #   publicKey = "<pubkey>";
      #   presharedKeyFile = config.age.secrets.zephyrus_wg0_preshared_key.path;
      #   allowedIPs = [
      #     "10.8.0.7/32"
      #     "fd47:4161:82f9::7/128"
      #   ];
      # }
      {
        # Dionysus
        publicKey = "tDfcWasj6SBCG+tFGl0UTZT0ZTiP5i+lCeN8o0Svtg4=";
        presharedKeyFile = config.age.secrets.dionysus_wg0_preshared_key.path;
        allowedIPs = [
          "10.8.0.8/32"
          "fd47:4161:82f9::8/128"
        ];
      }
    ];
  };
}
