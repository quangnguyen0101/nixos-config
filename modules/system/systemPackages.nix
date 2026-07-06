{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		tree
		git
		github-cli
		vim
		wget
		curl
		unzip
		fastfetch
		efibootmgr
	];
}
