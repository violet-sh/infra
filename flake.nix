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

    nixos-hardware.url = "nixos-hardware/master";

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
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

    systems.url = "github:nix-systems/default";
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
      systems,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      eachSystem = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "x86_64-linux"
      ];
    in
    {
      packages = eachSystem (system: import ./packages nixpkgs.legacyPackages.${system});

      formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      overlays = import ./overlays { };

      nixosConfigurations = {
        aether = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs outputs;
          };

          modules = [
            ./presets/nixos/common.nix
            ./presets/nixos/server.nix
            ./machines/aether
          ];
        };

        zeus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs outputs;
          };

          modules = [
            nixos-hardware.nixosModules.framework-12th-gen-intel

            ./presets/nixos/common.nix
            ./presets/nixos/laptop.nix
            ./machines/zeus
          ];
        };

        hera = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs outputs;
          };

          modules = [
            ./presets/nixos/common.nix
            ./presets/nixos/desktop.nix
            ./machines/hera
          ];
        };

        hestia = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs outputs;
          };

          modules = [
            ./presets/nixos/common.nix
            ./presets/nixos/server.nix
            ./machines/hestia
          ];
        };

        athena = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs outputs;
          };

          modules = [
            ./presets/nixos/common.nix
            ./presets/nixos/server.nix
            # ./machines/aethna
          ];
        };

        zephyrus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs outputs;
          };

          modules = [
            ./presets/nixos/common.nix
            ./presets/nixos/server.nix
            # ./machines/zephyrus
          ];
        };
      };

      deploy = {
        fastConnection = true;
        remoteBuild = true;
        user = "root";
        sshUser = "tibs";

        nodes.aether = {
          hostname = "aether.wg";
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.aether;
        };

        nodes.hera = {
          hostname = "hera.wg";
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.hera;
        };

        nodes.hestia = {
          hostname = "hestia.wg";
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.hestia;
        };

        nodes.athena = {
          hostname = "athena.wg";
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.athena;
        };

        nodes.zephyrus = {
          hostname = "zephyrus.wg";
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.zephyrus;
        };

        checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
      };
    };
}
