{
  description  = "Basic Flake";

   inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      type = "github";
      owner = "numtide";
      repo = "treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      };
  };
 
  outputs = { self, nixpkgs, home-manager, nvf, treefmt-nix, ... }: {
      nixosModules = ./modules/nixos;
      
#      homeManagerModules = ./modules/home-manager;

      nixosConfigurations.think = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit (self) inputs; };
           modules = [
             ./nixos/configuration.nix
             nvf.nixosModules.default
           ];
         };
        };
 }
