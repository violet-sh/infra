let
  # --- Users ---
  tibs = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQ2j1Tc6TMied/Hft9RWZpB+OFlN+TgsDikeJpe8elQ";
  ragenix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfxuU8uMTeoNhOn0AM/LysdLrOxfeYT0c/N+Rh/ChgY";

  # --- Systems ---
  aether = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAS7u6vSAlciB0vlRoF8Zjr5pZ/xxkxC5NSLXkEyyUZb";
  zeus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB91EFeUtoOCYSNamJT3dFydLVQKDuYFVyax3KQkA6mx";
  hera = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO0m7hkaTc1rQQKnHmXcHKw3/w0awR0TSji25QcUOonI";
  hestia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHx2nkrX8P+FdvF5V6fvVt7XZw2Et6vIbkFVNbGvGZtX";
  # athena = "ssh-ed25519 <key>";
  # zephyrus = "ssh-ed25519 <key>";

  systems = [
    aether
    zeus
    hera
    hestia
    # athena
    # zephyrus
  ];
in
{
  "ragenix_key.age".publicKeys = [
    tibs
    ragenix
  ] ++ systems;
  "aether_wg0_key.age".publicKeys = [
    tibs
    ragenix
    aether
  ];
  "zeus_wg0_key.age".publicKeys = [
    tibs
    ragenix
    zeus
  ];
  "zeus_wg0_preshared_key.age".publicKeys = [
    tibs
    ragenix
    aether
    zeus
  ];
  "hera_wg0_key.age".publicKeys = [
    tibs
    ragenix
    hera
  ];
  "hera_wg0_preshared_key.age".publicKeys = [
    tibs
    ragenix
    aether
    hera
  ];
  "hermes_wg0_preshared_key.age".publicKeys = [
    tibs
    ragenix
    aether
  ];
  "hestia_wg0_key.age".publicKeys = [
    tibs
    ragenix
    hestia
  ];
  "hestia_wg0_preshared_key.age".publicKeys = [
    tibs
    ragenix
    aether
    hestia
  ];
  "dionysus_wg0_preshared_key.age".publicKeys = [
    tibs
    ragenix
    aether
  ];
  "wgautomesh_gossip_secret.age".publicKeys = [
    tibs
    ragenix
  ] ++ systems;
  "woodpecker_github_client.age".publicKeys = [
    tibs
    ragenix
    aether
  ];
  "woodpecker_github_secret.age".publicKeys = [
    tibs
    ragenix
    aether
  ];
  "woodpecker_agent_secret.age".publicKeys = [
    tibs
    ragenix
    aether
  ];
  "bunny_tls_api_key.age".publicKeys = [
    tibs
    ragenix
    aether
  ];
  "cloudflare_tls_api_key.age".publicKeys = [
    tibs
    ragenix
    aether
  ];
}
