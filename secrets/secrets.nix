let
  # --- Users ---
  tibs = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQ2j1Tc6TMied/Hft9RWZpB+OFlN+TgsDikeJpe8elQ";

  # --- Systems ---
  zeus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB91EFeUtoOCYSNamJT3dFydLVQKDuYFVyax3KQkA6mx";
  atlas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZHhOo/3WHTiG/2q1soJG8sJWSqWP70dBh+Gh/fejV5";
  aether = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAS7u6vSAlciB0vlRoF8Zjr5pZ/xxkxC5NSLXkEyyUZb";
  apollo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHx2nkrX8P+FdvF5V6fvVt7XZw2Et6vIbkFVNbGvGZtX";

  systems = [
    zeus
    atlas
    aether
    apollo
  ];
in
{
  "zeus_wg0_key.age".publicKeys = [
    tibs
    zeus
    aether
  ];
  "zeus_wg0_preshared_key.age".publicKeys = [
    tibs
    zeus
    aether
  ];
}
