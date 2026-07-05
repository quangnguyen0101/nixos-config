{ config, pkgs, ... }:

{
	programs.regreet = {
		enable = true;
		#theme.name = "Adwaita";
		#font = {
		#	name = "Cantarell";
		#	size = 16;
		#};
		#cursorTheme.name = "Adwaita";

		cageArgs = [
			"-s"
			"-d"
			"-m"
			"last"
		];
	};

	services.greetd = {
		enable = true;
	};
}
