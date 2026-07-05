{
	description = "NixOS configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
		home-manager.url = "github:nix-community/home-manager";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
		
		caelestia-shell = {
			url = "github:caelestia-dots/shell";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs =
	inputs@{ self, nixpkgs, home-manager, ... }:
	{
		nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem 
		{
			system = "x86_64-linux";
			modules = 
			[
				./hosts/nixos-btw/configuration.nix
				home-manager.nixosModules.home-manager
					{
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.extraSpecialArgs = { inherit inputs; };
						home-manager.users.sh4d0wph4nt0m = ./home/sh4d0wph4nt0m/home.nix;
					}
        		];
		};
	};
}
