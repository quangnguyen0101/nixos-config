{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      tr = "tree";
      clr = "clear";
      shut = "shutdown -h now";
      update = "sudo nixos-rebuild switch --flake ~/nixos-config#nixos-btw";
    };

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "docker"
        "history-substring-search"
      ];
    };

    # Thêm Zsh function và script khởi động vào đây
    initContent = ''
      # Tự động chạy TMUX
      if [ -z "$TMUX" ] && [ -n "$PS1" ]; then
        exec tmux new-session -A -s main
      fi

      # Zsh Function để update rmpc nhanh
      ru() {
        echo "🎵 Đang cập nhật kho nhạc..."
        rmpc update
        rmpc
      }
    '';
  };
}
