{
  description  = "Basic Flake";

   inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";  
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
    minimal-emacs-d = {
      url = "github:jamescherti/minimal-emacs.d";
      flake = false;
    };

  };
 
  outputs = { self, nixpkgs, home-manager, nvf, treefmt-nix, emacs-overlay, ... }: {
      nixosModules = ./modules/nixos;
      
#      homeManagerModules = ./modules/home-manager;

      nixosConfigurations.think = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit (self) inputs; };
           modules = [
             ({config, pkgs, ...}: {
               nixpkgs.overlays = [ 
                 emacs-overlay.overlay ];})
             ./nixos/configuration.nix
             nvf.nixosModules.default
           ];
         };
        };
 }
