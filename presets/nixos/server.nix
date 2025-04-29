{ ... }:
{
  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    fail2ban = {
      enable = true;
      ignoreIP = [
        # Private addresses
        "10.0.0.0/8"
        "172.16.0.0/12"
        "192.168.0.0/16"
        "169.254.0.0/16"
        "127.0.0.0/8"
        "fc00::/7"
        "fe80::/10"
        # UVM
        "132.198.0.0/16"
        "2620:104:e000::/40"
        # AetherNet
        "2602:fbcf:d0::/44"
      ];
    };

  };
}
