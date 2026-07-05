{ config, pkgs, ... }:

{
	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";
	#console = {
	#	font = "Lat2-Terminus16";
	#	keyMap = "us";
	#	useXkbConfig = true; # use xkb.options in tty.
	#};

	i18n.inputMethod = {
   		type = "fcitx5";
  	 	enable = true;
   		fcitx5 = {
			waylandFrontend = true;
			addons = with pkgs; [
     				fcitx5-bamboo
     			];
		};
 	};
}
