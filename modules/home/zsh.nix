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
      op = "opencode";
      nx = "cd ~/nixos-config";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#nixos-btw";
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
      # Graphical session display env (Hyprland): phục hồi khi pane tmux cũ thiếu.
      # Chỉ áp khi đang có X-wayland socket, không phải SSH.
      if [ -z "$SSH_CONNECTION" ]; then
        if [ -e /tmp/.X11-unix/X0 ] && [ -z "$DISPLAY" ]; then
          export DISPLAY=":0"
        fi
        if [ -n "$XDG_RUNTIME_DIR" ] && [ -e "$XDG_RUNTIME_DIR/wayland-1" ] && [ -z "$WAYLAND_DISPLAY" ]; then
          export WAYLAND_DISPLAY="wayland-1"
        fi
      fi

      # Tự động chạy TMUX
      if [ -z "$TMUX" ] && [ -n "$PS1" ]; then
        exec tmux new-session -A -s main
      fi

      # Zsh Function để update rmpc nhanh
      ru() {
        rmpc update
        echo "🎵 Kho nhạc đã được cập nhật thành công!"
        sleep 3
        rmpc
      }

      # Icon ⚡ bên phải prompt khi keep-awake đang giữ máy
      _keep_awake_prompt() {
        if systemctl --user is-active --quiet keep-awake 2>/dev/null; then
          RPROMPT='%F{green}⚡%f'
        else
          RPROMPT=
        fi
      }
      precmd_functions+=(_keep_awake_prompt)
    '';
  };
}
