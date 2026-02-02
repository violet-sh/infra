let
  # --- Users ---
  violet = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQ2j1Tc6TMied/Hft9RWZpB+OFlN+TgsDikeJpe8elQ";
  ragenix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfxuU8uMTeoNhOn0AM/LysdLrOxfeYT0c/N+Rh/ChgY";

  # --- Systems ---
  aether = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC6cPj2FiQNmW3EBDC526Bi7XYynLr1YkR05T5drK0X1";
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
    violet
    ragenix
  ]
  ++ systems;
  "aether_wg0_key.age".publicKeys = [
    violet
    ragenix
    aether
  ];
  "zeus_wg0_key.age".publicKeys = [
    violet
    ragenix
    zeus
  ];
  "zeus_wg0_preshared_key.age".publicKeys = [
    violet
    ragenix
    aether
    zeus
  ];
  "hera_wg0_key.age".publicKeys = [
    violet
    ragenix
    hera
  ];
  "hera_wg0_preshared_key.age".publicKeys = [
    violet
    ragenix
    aether
    hera
  ];
  "hermes_wg0_preshared_key.age".publicKeys = [
    violet
    ragenix
    aether
  ];
  "hestia_wg0_key.age".publicKeys = [
    violet
    ragenix
    hestia
  ];
  "hestia_wg0_preshared_key.age".publicKeys = [
    violet
    ragenix
    aether
    hestia
  ];
  "dionysus_wg0_preshared_key.age".publicKeys = [
    violet
    ragenix
    aether
  ];
  "wgautomesh_gossip_secret.age".publicKeys = [
    violet
    ragenix
  ]
  ++ systems;
  "woodpecker_github_client.age".publicKeys = [
    violet
    ragenix
    aether
  ];
  "woodpecker_github_secret.age".publicKeys = [
    violet
    ragenix
    aether
  ];
  "woodpecker_agent_secret.age".publicKeys = [
    violet
    ragenix
    aether
  ];
  "caddy_env.age".publicKeys = [
    violet
    ragenix
    aether
  ];
  "bunny_tls_api_key.age".publicKeys = [
    violet
    ragenix
    aether
  ];
  "cloudflare_tls_api_key.age".publicKeys = [
    violet
    ragenix
    aether
  ];
}
