{
  description = "My personal NixOS-based infrastructure";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    catppuccin.url = "github:catppuccin/nix";
    nixos-hardware.url = "nixos-hardware/master";
    nur.url = "github:nix-community/NUR";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.agenix.follows = "agenix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ###
    # For input follows only
    systems.url = "github:nix-systems/default";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      catppuccin,
      deploy-rs,
      home-manager,
      nixos-hardware,
      nur,
      ragenix,
      rust-overlay,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        zeus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
          };

          modules = [
            nixos-hardware.nixosModules.framework-12th-gen-intel

            ./secrets
            ./presets/common.nix
            ./presets/desktop.nix
            ./presets/laptop.nix
            ./machines/zeus
          ];
        };

        atlas = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
          };

          modules = [
            ./secrets
            ./presets/common.nix
            ./presets/desktop.nix
            ./machines/atlas
          ];
        };

        aether = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
          };

          modules = [
            ./secrets
            ./presets/common.nix
            ./presets/desktop.nix
            ./machines/aether
          ];
        };

        apollo = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
          };

          modules = [
            ./secrets
            ./presets/common.nix
            ./presets/desktop.nix
            ./machines/apollo
          ];
        };

      };

      deploy = {
        fastConnection = true;
        remoteBuild = true;
        user = "root";
        sshUser = "tibs";

        nodes.atlas = {
          hostname = "atlas.wg";
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.atlas;
        };

        nodes.aether = {
          hostname = "aether.wg";
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.aether;
        };

        nodes.apollo = {
          hostname = "apollo.wg";
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.apollo;
        };

        checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
