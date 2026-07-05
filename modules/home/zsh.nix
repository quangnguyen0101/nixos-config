{ pkgs, ... }:

{
	programs.zsh = {
  		enable = true;
  		enableCompletion = true;
  		autosuggestion.enable = true;
  		syntaxHighlighting.enable = true;

  		shellAliases = {
    			tr = "tree -a";
			clr = "clear";
    			update = "sudo nixos-rebuild switch --flake ~/nixos-config#nixos-btw";
  		};

		oh-my-zsh = {
      			enable = true;
      			theme = "robbyrussell"; # theme mặc định, đổi tên khác nếu muốn
      			plugins = [
        			"git"
        			"sudo"
        			"docker"
        			"history-substring-search"
      			];
    		};

		initContent = ''
      			if [ -z "$TMUX" ] && [ -n "$PS1" ]; then
        			exec tmux new-session -A -s main
      			fi
    		'';

	};	
}
