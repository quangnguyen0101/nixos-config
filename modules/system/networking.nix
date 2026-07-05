{ config, pkgs, ... }:

{

	# Configure network connections interactively with nmcli or nmtui.
	networking.networkmanager.enable = true;
	networking.firewall.enable = true;
}
