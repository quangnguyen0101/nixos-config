{ config, pkgs, ... }:

{
	imports = [ 
		../../modules/home/caelestia.nix
		../../modules/home/userPackages.nix  
	];

	home.username = "sh4d0wph4nt0m";
	home.homeDirectory = "/home/sh4d0wph4nt0m";
	home.stateVersion = "26.05";
	
	programs.home-manager.enable = true;
}
