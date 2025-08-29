# Violet's infra

My personal NixOS-based infrastructure

## nuh
The Nix Update Helper, a CLI tool for managing and updating NixOS

## Directories
- `machines` - Configuration files for NixOS machines
- `modules` - Custom modules for Home Manager and NixOS
- `overlays` - Custom overlays for including custom packages
- `packages` - Custom packages not in nixpkgs
- `presets` - Presets for Home Manager and NixOS
- `scripts` - Helper scripts for finished systems
- `secrets` - Age-encrypted secrets

## Machines
| Hostname | WireGuard IP | OS     | Description             |
|----------|--------------|--------|-------------------------|
| Aether   | 10.8.0.1     | NixOS  | Primary VPS (Clouvider) |
| Zeus     | 10.8.0.2     | NixOS  | Laptop                  |
| Hera     | 10.8.0.3     | NixOS  | Desktop                 |
| Hermes   | 10.8.0.4     | iOS    | Phone                   |
| Hestia   | 10.8.0.5     | NixOS  | Home NAS                |
| Athena   | 10.8.0.6     | NixOS  | Uni NAS                 |
| Zephyrus | 10.8.0.7     | NixOS  | Backup VPS (zfs.rent)   |
| Dionysus | 10.8.0.8     | iPadOS | Tablet                  |

### Other hosts
- Eos: DNS nameserver 1
- Nyx: DNS nameserver 2
