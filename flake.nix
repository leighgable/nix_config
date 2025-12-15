{
  description  = "Basic Flake";

   inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    home-manager.url = "github:nix-community/home-manager";
   };
 
  outputs = { self, nixpkgs, home-manager, ... }: {
      nixosModules = ./modules/nixos;
      
#      homeManagerModules = ./modules/home-manager;

      nixosConfigurations.think = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit (self) inputs; };
           modules = [
             ./nixos/configuration.nix
           ];
         };
        };
 }
