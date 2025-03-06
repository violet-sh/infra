# Tibs' infra

My personal NixOS-based infrastructure

## nuh
The Nix Update Helper, a CLI tool for managing and updating NixOS

## Directories
- `machines` - Configuration files for NixOS machines
- `modules` - Custom modules for Home Manager and NixOS
- `packages` - Custom packages not in nixpkgs
- `presets` - Presets for Home Manager and NixOS
- `scripts` - Helper scripts for finished systems
- `secrets` - Age-encrypted secrets

## Machines
| Hostname | WireGuard IP | Description |
|----------|--------------|-------------|
| Aether   | 10.8.0.1     | Primary VPS |
| Zeus     | 10.8.0.2     | Laptop      |
| Hera     | 10.8.0.3     | Desktop     |
| Hermes   | 10.8.0.4     | Phone       |
| Hestia   | 10.8.0.5     | Home NAS    |
| Athena   | 10.8.0.6     | Uni NAS     |
| Zephyrus | 10.8.0.7     | Backup VPS  |
| Dionysus | 10.8.0.8     | Tablet      |

### Other hosts
- Eos: DNS nameserver 1
- Nyx: DNS nameserver 2
